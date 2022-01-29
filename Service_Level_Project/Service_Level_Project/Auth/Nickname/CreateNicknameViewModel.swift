//
//  CreateNicknameViewModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/25.
//

import Foundation

import RxSwift
import RxCocoa
import RxRelay

final class CreateNicknameViewModel: baseViewModel {
    
    //MARK: Input, Output
    struct Input {
        let inputNickname: Driver<String>
        let buttonTapEvent: Signal<Void> // 버튼, 알람, 토스트?
    }
    
    struct Output {
        let outputNickname: Driver<String>
        let nicknameUIStatus: Driver<Bool>
        let nextButtonClicked: Driver<Bool>
        let sendToastMessage: Driver<String>
    }
    
    private let userNickname = BehaviorRelay<String>(value: "")
    private let nicknameStatus = BehaviorRelay<Bool>(value: false)
    
    
    private let nextButtonClicked = BehaviorRelay<Bool>(value: false)
    private let sendToastMessage = PublishRelay<String>()
    
    var disposeBag = DisposeBag()
    
    //MARK: Transform(input:)
    func transform(input: Input) -> Output {
        let nickname = input.inputNickname
            .distinctUntilChanged()
        
        nickname.drive(onNext: { [weak self] text in
            guard let self = self else {return}
            // UserDefaults 넣을 값
            self.userNickname.accept(text)
            // UI 상태
            let status = text.count > 0 ? true : false
            self.nicknameStatus.accept(status)
        }).disposed(by: disposeBag)
        
        // 금지 닉네임: 바람의나라, 미묘한도사, 고래밥
        input.buttonTapEvent.map(()->())
            .asObservable()
            .subscribe(onNext: { _ in
                print("test: 111")
                
                self.nextButtonClicked.accept(true)
            }).disposed(by: disposeBag)
        
//        nickname.map(validationNickname)
//            .drive(onNext: { [weak self] status in
//                guard let self = self else {return}
//                if !status {
//                    self.sendToastMessage.accept("닉네임은 1자 이상 10자 이내로 부탁드려요.")
//                }
//            })
//            .disposed(by: disposeBag)
        
        return Output(
            outputNickname: userNickname.asDriver(),
            nicknameUIStatus: nicknameStatus.asDriver(), nextButtonClicked: nextButtonClicked.asDriver(), sendToastMessage: sendToastMessage.asDriver(onErrorJustReturn: "")
        )
    }
    
//    private func validationNickname(_ text: String) -> Bool {
//        let status = text.count > 10 ? true : false
//
//        return status
//    }
    
    //MARK: 기본 텍스트 입력
    let Title = "닉네임을 입력해주세요"
    let customButtonTitle = "다음"
    
}

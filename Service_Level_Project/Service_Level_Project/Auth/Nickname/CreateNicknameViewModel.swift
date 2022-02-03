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

final class CreateNicknameViewModel: BaseViewModel {
    
    //MARK: Input, Output
    struct Input {
        let inputNickname: Driver<String>
//        let buttonTapEvent: Signal<Void> // 버튼, 알람, 토스트?
    }
    
    struct Output {
        let outputNickname: Driver<String>
        let nicknameUIStatus: Driver<Bool>
    }
    
    private let userNickname = BehaviorRelay<String>(value: "")
    private let nicknameStatus = BehaviorRelay<Bool>(value: false)
    
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
    
        return Output(
            outputNickname: userNickname.asDriver(),
            nicknameUIStatus: nicknameStatus.asDriver()
        )
    }
    
    //MARK: 기본 텍스트 입력
    let Title = "닉네임을 입력해주세요"
    let customButtonTitle = "다음"
    
}

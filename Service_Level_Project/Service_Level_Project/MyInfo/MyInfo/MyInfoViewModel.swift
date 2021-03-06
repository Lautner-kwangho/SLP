//
//  MyInfoViewModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/02.
//

import Foundation

import RxSwift
import RxCocoa
import RxRelay

struct MyInfoData {
    var image: String
    var title: String
}

final class MyInfoViewModel: BaseViewModel {
    // 추가 기능이 생긴다면 ?? 그래서 만들어서 냅둠
    //MARK: Input, Output
    struct Input {
        
    }
    
    struct Output {
        let userNickName: String
    }
    //MARK: 기본 텍스트 입력
    var data = [
        MyInfoData(image: "notice", title: "공지사항"),
        MyInfoData(image: "question", title: "자주 묻는 질문"),
        MyInfoData(image: "personalQuestion", title: "1:1 문의"),
        MyInfoData(image: "alertSetting", title: "알림 설정"),
        MyInfoData(image: "permit", title: "이용약관")
    ]
    
    let tableCellHeight = 75.0
    var userName = "김새싹"
    
    static var myData = BehaviorRelay<SeSacLoginModel>(value: SeSacLoginModel())
    lazy var list = BehaviorRelay<[MyInfoData]>(value: data)
    
    var disposeBag = DisposeBag()
    
    //MARK: Transform(input:)
    func transform(input: Input) -> Output {
        
        MyInfoViewModel.myData.asDriver()
            .drive(onNext: { [weak self] model in
                self?.userName = model.nick
                UserDefaults.standard.set(model.uid, forKey: UserDefaultsManager.uid)
            })
            .disposed(by: disposeBag)
        
        return Output(userNickName: userName)
    }

}

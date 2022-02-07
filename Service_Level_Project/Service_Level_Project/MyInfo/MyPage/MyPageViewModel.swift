//
//  MyPageViewModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/06.
//

import Foundation

import RxSwift
import RxCocoa
import RxRelay

struct MyPageData {
    var title: String
}

final class MyPageViewModel: BaseViewModel {
    
    //MARK: Input, Output
    struct Input {
        
    }
    
    struct Output {
        let userData: SeSacLoginModel
    }
    
    var tableData = [
        MyPageData(title: "내 성별"),
        MyPageData(title: "자주하는 취미"),
        MyPageData(title: "내 번호 검색 허용"),
        MyPageData(title: "상대방 연령대"),
        MyPageData(title: "회원탈퇴")
    ]
    var userData = SeSacLoginModel()
    static var maleSwitch = false
    static var femaleSwitch = false
    static var searchSwitch = false
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        MyInfoViewModel.myData.asDriver()
            .drive(onNext: { [weak self] data in
                guard let self = self else {return}
                self.userData = data
            })
            .disposed(by: disposeBag)
        
        return Output(userData: userData)
    }
    
}

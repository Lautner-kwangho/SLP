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

typealias updateData = (Int, Int, Int, Bool, Bool, String)

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
    var update: updateData?
    
    static var maleSwitch = false
    static var femaleSwitch = false
    static var searchSwitch = false
    
    static var saveSearchable = BehaviorRelay<Int>(value: 0)
    static var saveAgeMin = BehaviorRelay<Int>(value: 18)
    static var saveAgeMax = BehaviorRelay<Int>(value: 65)
    static var maleGender = BehaviorRelay<Bool>(value: false)
    static var femaleGender = BehaviorRelay<Bool>(value: false)
    static var hobby = BehaviorRelay<String>(value: "")
    
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
    
    func updateUsetInfomation() {
        let search = MyPageViewModel.saveSearchable
        let ageMin = MyPageViewModel.saveAgeMin
        let ageMax = MyPageViewModel.saveAgeMax
        let male = MyPageViewModel.maleGender
        let female = MyPageViewModel.femaleGender
        let hobby = MyPageViewModel.hobby
        
        Observable.combineLatest(search, ageMin, ageMax, male, female, hobby)
            .asDriver(onErrorJustReturn: (0, 18, 65, false, false, "String"))
            .drive(onNext: { search, min, max, girl, men, hobby in
                self.update = (search, min, max, girl, men, hobby)
            })
            .disposed(by: disposeBag)

    }
    
}

//
//  HobbyViewModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/11.
//

import Foundation

import RxSwift
import RxCocoa
import RxRelay

class HobbyViewModel: BaseViewModel {
    
    struct Input {
        let searchBarText: Driver<String>
        let removeItem: Driver<String>
    }
    
    struct Output {
        let myHobbyList: Driver<Set<String>>
        let status: Driver<Bool>
    }

    var myHobbyList = PublishRelay<Set<String>>()
    var sendMyHobbylist = Set<String>()
    var status = BehaviorRelay<Bool>(value: true)
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        input.removeItem.asDriver()
            .drive(onNext: { [weak self] removeNumber in
                guard let self = self else {return}
                self.sendMyHobbylist.remove(removeNumber)
                self.myHobbyList.accept(self.sendMyHobbylist)
            })
            .disposed(by: disposeBag)
        
        input.searchBarText.asDriver()
            .drive(onNext: { [weak self] searchText in
                guard let self = self else {return}
                
                if searchText.contains(" ") {
                    let divide = searchText.components(separatedBy: " ")
                    divide.forEach {
                        self.sendMyHobbylist.insert($0)
                        self.myHobbyList.accept(self.sendMyHobbylist)
                    }
                } else {
                    self.sendMyHobbylist.insert(searchText)
                    self.myHobbyList.accept(self.sendMyHobbylist)
                }
            })
            .disposed(by: disposeBag)
        
        myHobbyList.asSignal()
            .emit(onNext: { [weak self] data in
                guard let self = self else {return}
                if data.count > 7 {
                    self.status.accept(false)
                } else {
                    self.status.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(myHobbyList: myHobbyList.asDriver(onErrorJustReturn: ["error"]),status: status.asDriver())
    }
}

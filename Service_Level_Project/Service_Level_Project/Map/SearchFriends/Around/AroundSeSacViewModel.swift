//
//  AroundSeSacViewModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/12.
//

import Foundation

import RxSwift
import RxCocoa
import RxRelay

class AroundSeSacViewModel: BaseViewModel {
    struct Input {
        
    }
    
    struct Output {
        let fromData: Signal<[QueueData?]>
    }
    
    static var myData = PublishRelay<SeSacSearchFreindsModel>()
    var fromData = PublishRelay<[QueueData?]>()
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        AroundSeSacViewModel.myData.asSignal()
            .emit(onNext: { [weak self] model in
                guard let self = self else {return }
                self.fromData.accept(model.fromQueueDB)
            })
            .disposed(by: disposeBag)
        
        return Output(fromData: self.fromData.asSignal())
    }
    
    func friendsList() {
        
        SeSacURLNetwork.friendsWithMe(region: UserDefaults.standard.integer(forKey: UserDefaultsManager.region), latitude: UserDefaults.standard.double(forKey: UserDefaultsManager.latitude), longitude: UserDefaults.standard.double(forKey: UserDefaultsManager.longitude))
    }
}

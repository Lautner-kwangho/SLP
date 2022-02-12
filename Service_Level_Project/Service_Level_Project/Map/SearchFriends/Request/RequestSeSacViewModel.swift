//
//  RequestSeSacViewModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/12.
//

import Foundation

import RxSwift
import RxCocoa
import RxRelay

class RequestSeSacViewModel: BaseViewModel {
    struct Input {
        
    }
    
    struct Output {
        let fromRequestData: Signal<[QueueData?]>
    }
    
    static var myData = PublishRelay<SeSacSearchFreindsModel>()
    var fromRequestData = PublishRelay<[QueueData?]>()
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        RequestSeSacViewModel.myData.asSignal()
            .emit(onNext: { [weak self] model in
                guard let self = self else {return }
                self.fromRequestData.accept(model.fromQueueDBRequested)
            })
            .disposed(by: disposeBag)
        
        return Output(fromRequestData: self.fromRequestData.asSignal())
    }
    
    func friendsList() {
        
        SeSacURLNetwork.friendsWithMe(region: UserDefaults.standard.integer(forKey: UserDefaultsManager.region), latitude: UserDefaults.standard.double(forKey: UserDefaultsManager.latitude), longitude: UserDefaults.standard.double(forKey: UserDefaultsManager.longitude))
    }
}

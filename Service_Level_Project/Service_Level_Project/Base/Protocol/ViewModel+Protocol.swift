//
//  ViewModel+Protocol.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/28.
//

import Foundation
import RxSwift

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}

//
//  LoginRealm.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/04.
//

import Foundation
import RealmSwift

class LoginRealm: Object {
    @Persisted var title: String
    @Persisted(primaryKey: true) var _id: ObjectId

//    음 이걸 다 넣어준다고..?
//    let _id: String
//    let __v: Int
//    let uid: String
//    let phoneNumber: String
//    let email: String
//    let FCMtoken: String
//    let nick: String
//    let birth: String
//    let gender: Int
//    let hobby: String
//    let comment: [String]
//    let reputation: [Int]
//    let sesac: Int
//    let sesacCollection: [Int]
//    let background: Int
//    let backgroundCollection: [Int]
//    let purchaseToken: [String]
//    let transactionId: [String]
//    let reviewedBefore: [String]
//    let reportedNum: Int
//    let reportedUser: [String]
//    let dodgepenalty: Int
//    let dodgeNum: Int
//    let ageMin: Int
//    let ageMax: Int
//    let searchable: Int
//    let createdAt: String
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
}

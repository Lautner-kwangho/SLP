//
//  ChatRealmModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/20.
//

import Foundation
import RealmSwift

class ChatRealmModel: Object {
    @Persisted var to: String
    @Persisted var from: String
    @Persisted var chat: String
    @Persisted var createdAt: String
    @Persisted(primaryKey: true) var _id: ObjectId
    
    convenience init(to: String, from: String, chat: String, createdAt: String) {
        self.init()
        self.to = to
        self.from = from
        self.chat = chat
        self.createdAt = createdAt
    }
}

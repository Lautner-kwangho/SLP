//
//  SendChatModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/14.
//

import Foundation

struct SendChatModel: Codable {
    let id: String
    let v: Int
    let to, from, chat: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case v = "__v"
        case to, from, chat, createdAt
    }
}

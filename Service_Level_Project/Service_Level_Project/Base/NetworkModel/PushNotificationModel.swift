//
//  PushNotificationModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/21.
//

import Foundation

struct PushNotificationModel: Codable {
    let googleCSenderID, googleCAE: String
    let body, uid: String?
    let googleCFid: String
    let aps: Aps
    let gcmMessageID, nick: String
    let matched, dodge, hobbyAccepted, hobbyRequest: String?

    enum CodingKeys: String, CodingKey {
        case googleCSenderID = "google.c.sender.id"
        case body
        case uid = "Uid"
        case googleCAE = "google.c.a.e"
        case googleCFid = "google.c.fid"
        case aps
        case gcmMessageID = "gcm.message_id"
        case nick = "Nick"
        case matched, dodge, hobbyAccepted, hobbyRequest
    }
}

struct Aps: Codable {
    let contentAvailable: Int
    let alert: Alert
    let mutableContent: String
    let category: String?

    enum CodingKeys: String, CodingKey {
        case contentAvailable = "content-available"
        case alert
        case mutableContent = "mutable-content"
        case category
    }
}

struct Alert: Codable {
    let title, body: String
}

//
//  SeSacSearchFreindsModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/09.
//

import Foundation


struct SeSacSearchFreindsMode: Codable {
    let fromQueueDB, fromQueueDBRequested: [QueueData?]
    let fromRecommend: [String]
}

struct QueueData: Codable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let hf, reviews: [String]
    let gender, type, sesac, background: Int
}

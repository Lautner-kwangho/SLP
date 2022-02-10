//
//  SeSacSearchFreindsModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/09.
//

import Foundation


struct SeSacSearchFreindsModel: Codable, Equatable {
    let fromQueueDB, fromQueueDBRequested: [QueueData?]
    let fromRecommend: [String]
}

struct QueueData: Codable, Equatable, Hashable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let hf, reviews: [String]
    let gender, type, sesac, background: Int
}

extension SeSacSearchFreindsModel {
    init() {
        self.init(fromQueueDB: [], fromQueueDBRequested: [], fromRecommend: [])
    }
}

extension QueueData {
    init() {
        self.init(uid: "", nick: "", lat: 0.0, long: 0.0, reputation: [], hf: [], reviews: [], gender: 0, type: 0, sesac: 0, background: 0)
    }
}

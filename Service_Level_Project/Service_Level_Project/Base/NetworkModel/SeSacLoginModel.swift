//
//  SeSacLoginModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/04.
//

import Foundation

struct SeSacLoginModel: Codable {
    
    var _id: String = ""
    var __v: Int = 0
    var uid: String = ""
    var phoneNumber: String = ""
    var email: String = ""
    var FCMtoken: String = ""
    var nick: String = ""
    var birth: String = ""
    var gender: Int = 0
    var hobby: String = ""
    var comment: [String] = []
    var reputation: [Int] = []
    var sesac: Int = 0
    var sesacCollection: [Int] = []
    var background: Int = 0
    var backgroundCollection: [Int] = []
    var purchaseToken: [String] = []
    var transactionId: [String] = []
    var reviewedBefore: [String] = []
    var reportedNum: Int = 0
    var reportedUser: [String] = []
    var dodgepenalty: Int = 0
    var dodgeNum: Int = 0
    var ageMin: Int = 0
    var ageMax: Int = 0
    var searchable: Int = 0
    var createdAt: String = ""
}

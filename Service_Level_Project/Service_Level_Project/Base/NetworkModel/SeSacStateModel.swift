//
//  SeSacStateModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/13.
//

import Foundation

struct SeSacStateModel: Codable {
    
    let dodged, matched, reviewed: Int
    let matchedNick, matchedUid: String
    
}

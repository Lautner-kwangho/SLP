//
//  PurchaseItem.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/23.
//

import Foundation

struct PurchaseItemModel {
    let sesac, background: Int?
    
    enum CodingKeys: String, CodingKey {
        case sesac, background
    }
}

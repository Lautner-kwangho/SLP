//
//  DataModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/08.
//

import Foundation

enum CheckDataModel {
    case gender(Int)
    case searchable(Int)
    
    var genderSwitch: String? {
        switch self {
        case let .gender(value):
            if value == -1 {
                return "성별없음"
            } else if value == 0 {
                return "남자"
            } else if value == 1 {
                return "여자"
            } else {
                return nil
            }
        @unknown default: return nil
        }
    }
    
    var searchable: Bool? {
        switch self {
        case let .searchable(value):
            if value == 1 {
                return true
            } else {
                return false
            }
        @unknown default: return nil
        }
    }
}

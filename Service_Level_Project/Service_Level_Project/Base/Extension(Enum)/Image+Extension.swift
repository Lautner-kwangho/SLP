//
//  Image+Extension.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/10.
//

import UIKit

enum SeSacUserImageManager: Int, CaseIterable {
    case sesac_face_1
    case sesac_face_2
    case sesac_face_3
    case sesac_face_4
    case sesac_face_5
    
    static func image(_ number: Int) -> UIImage {
        return UIImage(named: "\(Self(rawValue: number).value!)")!
    }
    
    static func imageName(_ number: Int) -> String {
        return "\(Self(rawValue: number).value!)"
    }
}

enum SeSacUserBackgroundImageManager: Int, CaseIterable {
    case sesac_background_1
    case sesac_background_2
    case sesac_background_3
    case sesac_background_4
    case sesac_background_5
    
    static func image(_ number: Int) -> UIImage {
        return UIImage(named: "\(Self(rawValue: number).value!)")!
    }
    
    static func imageName(_ number: Int) -> String {
        return "\(Self(rawValue: number).value!)"
    }
}

enum SeSacMapButtonImageManager: Int, CaseIterable {
    case friendsSearch
    case friendsWait
    case friendsMatch
    
    static func image(_ number: Int) -> UIImage {
        return UIImage(named: "\(Self(rawValue: number).value!)")!
    }
    
    static func imageName(_ number: Int) -> String {
        return "\(Self(rawValue: number).value!)"
    }
}

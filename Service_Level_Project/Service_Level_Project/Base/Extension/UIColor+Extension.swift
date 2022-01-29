//
//  UIColor+Extension.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/19.
//

import UIKit

enum SacColor: String {
    case white
    case black
    case green
    case whitegreen
    case yellowgreen
    case gray1
    case gray2
    case gray3
    case gray4
    case gray5
    case gray6
    case gray7
    case error
    case focus
    case success
    
    static func color(_ color: SacColor) -> UIColor {
        return UIColor(named: color.rawValue)!
    }
}

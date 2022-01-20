//
//  UIFont+Extension.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/18.
//

import UIKit

enum Font {
    case display1_R
    case title1_M
    case title2_R
    case title3_M
    case title4_R
    case title5_M
    case title5_R
    case body1_M
    case body2_R
    case body3_R
    case body4_R
    case caption_R
    
    var weight: UIFont.Weight {
        switch self {
        case .display1_R:
            return .regular
        case .title1_M:
            return .medium
        case .title2_R:
            return .regular
        case .title3_M:
            return .medium
        case .title4_R:
            return .regular
        case .title5_M:
            return .medium
        case .title5_R:
            return .regular
        case .body1_M:
            return .medium
        case .body2_R:
            return .regular
        case .body3_R:
            return .regular
        case .body4_R:
            return .regular
        case .caption_R:
            return .regular
        }
    }
    
    func ofSize(size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: self.weight)
    }
    static func display1_R20() -> UIFont {
        return Font.display1_R.ofSize(size: 20)
    }
    static func title1_M16() -> UIFont {
        return Font.title1_M.ofSize(size: 16)
    }
    static func title2_R16() -> UIFont {
        return Font.title2_R.ofSize(size: 16)
    }
    static func title3_M14() -> UIFont {
        return Font.title3_M.ofSize(size: 14)
    }
    static func title4_R14() -> UIFont {
        return Font.title4_R.ofSize(size: 14)
    }
    static func title5_M12() -> UIFont {
        return Font.title5_M.ofSize(size: 12)
    }
    static func title6_R12() -> UIFont {
        return Font.title5_R.ofSize(size: 12)
    }
    static func body1_M16() -> UIFont {
        return Font.body1_M.ofSize(size: 16)
    }
    static func body2_R16() -> UIFont {
        return Font.body2_R.ofSize(size: 16)
    }
    static func body3_R14() -> UIFont {
        return Font.body3_R.ofSize(size: 14)
    }
    static func body4_R12() -> UIFont {
        return Font.body4_R.ofSize(size: 12)
    }
    static func caption_R10() -> UIFont {
        return Font.caption_R.ofSize(size: 10)
    }
    
}

extension UILabel {
    func setLineHeight(font: Font) {
        var lineHeight: CGFloat = 0.0
        switch font {
            // 아 기본 160%에서 그냥 바뀐거였네.. 기본 1.08에서..
            // 아 아니네 팀원이랑 이야기 해봐야겠다;
        case .display1_R, .title1_M, .title2_R, .title3_M, .title4_R, .caption_R:
            lineHeight = 1.6//1.08
        case .title5_M, .title5_R:
            lineHeight = 1.01
        case .body1_M, .body2_R:
            lineHeight = 1.25
        case .body3_R:
            lineHeight = 1.15
        case .body4_R:
            lineHeight = 1.22
        }
        print(lineHeight)
        guard let text = self.text else {return}
        let attributeString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight
        attributeString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributeString.length))
        self.attributedText = attributeString
    }
}

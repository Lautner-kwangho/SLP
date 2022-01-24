//
//  Custom+UIButton+Rx.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/19.
//

import UIKit
import SnapKit

enum buttonType {
    // icon 있으면 true, 없으면 false
    case h48(type: buttonCase, icon: Bool?)
    case h40(type: buttonCase, icon: Bool?)
    case h32(type: buttonCase, icon: Bool)
}

enum buttonCase: CaseIterable {
    case inactive
    case fill
    case outline
    case cancel
    case disable
    
    static func customLayout(_ button: UIButton, _ type: buttonCase) {
        button.layer.cornerRadius = 8
        button.titleLabel?.font = Font.body3_R14()
        
        switch type {
        case .inactive:
            button.setTitle(button.currentTitle, for: .normal)
            button.setTitleColor(SacColor.color(.black), for: .normal)
            button.backgroundColor = .clear
            button.layer.borderWidth = 1
            button.layer.borderColor = SacColor.color(.gray4).cgColor
        case .fill:
            button.setTitle(button.currentTitle, for: .normal)
            button.setTitleColor(SacColor.color(.white), for: .normal)
            button.backgroundColor = SacColor.color(.green)
            button.layer.borderWidth = 0
        case .outline:
            button.setTitle(button.currentTitle, for: .normal)
            button.setTitleColor(SacColor.color(.green), for: .normal)
            button.backgroundColor = .clear
            button.layer.borderWidth = 1
            button.layer.borderColor = SacColor.color(.green).cgColor
        case .cancel:
            button.setTitle(button.currentTitle, for: .normal)
            button.setTitleColor(SacColor.color(.black), for: .normal)
            button.backgroundColor = SacColor.color(.gray2)
            button.layer.borderWidth = 0
        case .disable:
            button.setTitle(button.currentTitle, for: .normal)
            button.setTitleColor(.red, for: .normal)
            button.setTitleColor(SacColor.color(.gray3), for: .normal)
            button.backgroundColor = SacColor.color(.gray6)
            button.layer.borderWidth = 0
        }
    }
}

class ButtonConfiguration: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(type: buttonCase) {
        self.init()
        
        self.layer.cornerRadius = 8
        self.titleLabel?.font = Font.body3_R14()
        
        switch type {
        case .inactive:
            self.setTitle(self.currentTitle, for: .normal)
            self.setTitleColor(SacColor.color(.black), for: .normal)
            self.backgroundColor = .clear
            self.layer.borderWidth = 1
            self.layer.borderColor = SacColor.color(.gray4).cgColor
        case .fill:
            self.setTitle(self.currentTitle, for: .normal)
            self.setTitleColor(SacColor.color(.white), for: .normal)
            self.backgroundColor = SacColor.color(.green)
            self.layer.borderWidth = 0
        case .outline:
            self.setTitle(self.currentTitle, for: .normal)
            self.setTitleColor(SacColor.color(.green), for: .normal)
            self.backgroundColor = .clear
            self.layer.borderWidth = 1
            self.layer.borderColor = SacColor.color(.green).cgColor
        case .cancel:
            self.setTitle(self.currentTitle, for: .normal)
            self.setTitleColor(SacColor.color(.black), for: .normal)
            self.backgroundColor = SacColor.color(.gray2)
            self.layer.borderWidth = 0
        case .disable:
            self.setTitle(self.currentTitle, for: .normal)
            self.setTitleColor(.red, for: .normal)
            self.setTitleColor(SacColor.color(.gray3), for: .normal)
            self.backgroundColor = SacColor.color(.gray6)
            self.layer.borderWidth = 0
        }
    }
    
    convenience init(customType: buttonType) {
        
        switch customType {
        case let .h48(type, _):
            self.init(type: type)
            self.snp.makeConstraints {
                $0.top.leading.trailing.equalTo(self)
                $0.height.equalTo(48)
            }
        case let .h40(type, _):
            self.init(type: type)
            self.snp.makeConstraints {
                $0.top.leading.trailing.equalTo(self)
                $0.height.equalTo(40)
            }
        case let .h32(type, icon):
            self.init(type: type)
            self.snp.makeConstraints {
                $0.top.leading.trailing.equalTo(self)
                $0.height.equalTo(36)
            }
            
            if icon {
                setImage(UIImage(systemName: "xmark"), for: .normal)
                semanticContentAttribute = .forceRightToLeft
                imageEdgeInsets = UIEdgeInsets(top: 0, left: 6.75, bottom: 0, right: 0)
                switch type {
                case .inactive:
                    tintColor = SacColor.color(.black)
                case .fill:
                    tintColor = SacColor.color(.black)
                case .outline:
                    tintColor = SacColor.color(.green)
                case .cancel:
                    tintColor = SacColor.color(.black)
                case .disable:
                    tintColor = SacColor.color(.gray4)
                }
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        self.init()
    }
}

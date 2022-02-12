//
//  Custom+UIButton+Rx.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/19.
//

import UIKit
import SnapKit

enum CustomButtonType {
    // icon 있으면 true, 없으면 false
    case h48(type: ButtonCase, icon: Bool?)
    case h40(type: ButtonCase, icon: Bool?)
    case h32(type: ButtonCase, icon: Bool)
}

enum ButtonCase: CaseIterable {
    case inactive
    case fill
    case outline
    case cancel
    case disable
}

class ButtonConfiguration: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(type: ButtonCase) {
        self.init()
        
        self.layer.cornerRadius = 8
        self.titleLabel?.font = Font.body3_R14()
        
        switch type {
        case .inactive:
            self.setTitle(self.currentTitle, for: .normal)
            self.setTitleColor(SacColor.color(.black), for: .normal)
            self.backgroundColor = SacColor.color(.white)
            self.layer.borderWidth = 1
            self.layer.borderColor = SacColor.color(.gray4).cgColor
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        case .fill:
            self.setTitle(self.currentTitle, for: .normal)
            self.setTitleColor(SacColor.color(.white), for: .normal)
            self.backgroundColor = SacColor.color(.green)
            self.layer.borderWidth = 0
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        case .outline:
            self.setTitle(self.currentTitle, for: .normal)
            self.setTitleColor(SacColor.color(.green), for: .normal)
            self.backgroundColor = SacColor.color(.white)
            self.layer.borderWidth = 1
            self.layer.borderColor = SacColor.color(.green).cgColor
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        case .cancel:
            self.setTitle(self.currentTitle, for: .normal)
            self.setTitleColor(SacColor.color(.black), for: .normal)
            self.backgroundColor = SacColor.color(.gray2)
            self.layer.borderWidth = 0
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        case .disable:
            self.setTitle(self.currentTitle, for: .normal)
            self.setTitleColor(.red, for: .normal)
            self.setTitleColor(SacColor.color(.gray3), for: .normal)
            self.backgroundColor = SacColor.color(.gray6)
            self.layer.borderWidth = 0
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
    }
    
    convenience init(customType: CustomButtonType) {
        
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
    
    func customLayout(_ type: ButtonCase) {
        switch type {
        case .inactive:
            self.setTitle(self.currentTitle, for: .normal)
            self.setTitleColor(SacColor.color(.black), for: .normal)
            self.backgroundColor = SacColor.color(.white)
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
            self.backgroundColor = SacColor.color(.white)
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
    
    required init?(coder: NSCoder) {
        self.init()
    }
}

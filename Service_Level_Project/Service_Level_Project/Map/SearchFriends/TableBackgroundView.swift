//
//  TableBackgroundView.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/12.
//

import UIKit

class TableBackgroundView: UIView {

    let backgroundImage = UIImageView().then {
        $0.image = UIImage(named: "tableImage")
    }
    
    var backgroundTitle = UILabel().then {
        $0.text = "아쉽게도 주변에 새싹이 없어요 ㅠ"
        let lineHeight = $0.setLineHeight(font: .display1_R)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.black)
        $0.textAlignment = .center
        $0.font = Font.display1_R20()
    }
    let backgroundSubTitle = UILabel().then {
        $0.text = "취미를 변경하거나 조금만 더 기다려 주세요!"
        let lineHeight = $0.setLineHeight(font: .title4_R)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.black)
        $0.textAlignment = .center
        $0.font = Font.title4_R14()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(text: String) {
        self.init()
        addSubview(backgroundImage)
        addSubview(backgroundTitle)
        addSubview(backgroundSubTitle)
        
        backgroundTitle.text = text
        
        backgroundImage.snp.makeConstraints {
            $0.center.equalTo(self)
        }
        
        backgroundTitle.snp.makeConstraints {
            $0.top.equalTo(backgroundImage.snp.bottom).offset(32)
            $0.leading.trailing.equalTo(self)
        }
        
        backgroundSubTitle.snp.makeConstraints {
            $0.top.equalTo(backgroundTitle.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

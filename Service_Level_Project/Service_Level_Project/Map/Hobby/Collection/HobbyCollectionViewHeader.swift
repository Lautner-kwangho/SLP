//
//  HobbyCollectionViewHeader.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/11.
//

import UIKit

class HobbyCollectionViewHeader: UICollectionReusableView {
    
    let title = UILabel().then {
        $0.text = "레이블 들어갈 자리"
        let lineHeight = $0.setLineHeight(font: .title6_R)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.black)
        $0.textAlignment = .left
        $0.font = Font.title6_R12()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        title.snp.makeConstraints { make in
            make.leading.equalTo(self).inset(16)
            make.trailing.equalTo(self)
            make.centerY.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//
//  MyPageTableViewCell.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/06.
//

import UIKit

class MyPageTableViewCell: UITableViewCell {
    
    let title = UILabel().then {
        let lineHeight = $0.setLineHeight(font: .title4_R)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.black)
        $0.textAlignment = .left
        $0.font = Font.title4_R14()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(title)
        title.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.leading.equalTo(self).inset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

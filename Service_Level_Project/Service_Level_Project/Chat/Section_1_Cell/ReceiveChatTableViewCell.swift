//
//  ChatTableViewCell.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/14.
//

import UIKit

class ReceiveChatTableViewCell: UITableViewCell {
    
    let receiveMessageBox = UITextView().then {
        $0.text = "받은 메시지"
        $0.contentInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        $0.textColor = SacColor.color(.black)
        $0.font = Font.body3_R14()
        $0.isScrollEnabled = false
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = SacColor.color(.gray4).cgColor
        $0.layer.borderWidth = 1
    }
    
    let receiveMessageTime = UILabel().then {
        $0.text = "받은 시간"
        $0.adjustsFontSizeToFitWidth = true
        let lineHeight = $0.setLineHeight(font: .title6_R)
        $0.attributedText = lineHeight
        $0.numberOfLines = 1
        $0.textColor = SacColor.color(.gray6)
        $0.textAlignment = .center
        $0.font = Font.title6_R12()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(receiveMessageBox)
        addSubview(receiveMessageTime)
        
        receiveMessageBox.snp.makeConstraints {
            $0.width.equalTo(self.frame.width * 0.7)
            $0.leading.equalTo(self).inset(16)
            $0.centerY.equalTo(self)
        }
        
        receiveMessageTime.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(18)
            $0.bottom.equalTo(receiveMessageBox)
            $0.leading.equalTo(receiveMessageBox.snp.trailing).offset(8)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

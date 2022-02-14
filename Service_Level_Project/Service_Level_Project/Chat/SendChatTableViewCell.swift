//
//  SendChatTableViewCell.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/14.
//

import UIKit

class SendChatTableViewCell: UITableViewCell {
    
    let sendMessageBox = UITextView().then {
        $0.text = "보낼 메시지"
        $0.contentInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        $0.textColor = SacColor.color(.black)
        $0.font = Font.body3_R14()
        $0.isScrollEnabled = false
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = SacColor.color(.gray4).cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = SacColor.color(.whitegreen)
    }
    
    let sendMessageTime = UILabel().then {
        $0.text = "보낼 시간"
        $0.adjustsFontSizeToFitWidth = true
        let lineHeight = $0.setLineHeight(font: .title6_R)
        $0.attributedText = lineHeight
        $0.numberOfLines = 1
        $0.textColor = SacColor.color(.gray6)
        $0.textAlignment = .center
        $0.font = Font.title6_R12()
    }
    
    let sendMessageStatus = UILabel().then {
        $0.text = "안 읽음"
        $0.adjustsFontSizeToFitWidth = true
        let lineHeight = $0.setLineHeight(font: .title6_R)
        $0.attributedText = lineHeight
        $0.numberOfLines = 1
        $0.textColor = SacColor.color(.green)
        $0.textAlignment = .center
        $0.font = Font.title6_R12()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(sendMessageBox)
        addSubview(sendMessageTime)
        addSubview(sendMessageStatus)
        
        sendMessageBox.snp.makeConstraints {
            $0.trailing.equalTo(self).inset(16)
            $0.centerY.equalTo(self)
            $0.width.equalTo(self.frame.width * 0.7)
        }
        
        sendMessageTime.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(18)
            $0.bottom.equalTo(sendMessageBox)
            $0.trailing.equalTo(sendMessageBox.snp.leading).inset(-8)
        }
        
        sendMessageStatus.snp.makeConstraints {
            $0.width.height.equalTo(sendMessageTime)
            $0.bottom.equalTo(sendMessageTime.snp.top)
            $0.leading.trailing.equalTo(sendMessageTime)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

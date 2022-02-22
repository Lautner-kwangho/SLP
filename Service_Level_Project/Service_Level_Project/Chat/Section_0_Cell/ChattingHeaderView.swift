//
//  ChattingHeaderView.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/14.
//

import UIKit

class ChattingHeaderView: UITableViewCell {
    
    let chatStartDateText = UILabel().then {
        $0.text = "1월 1일 월요일"
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.adjustsFontSizeToFitWidth = true
        let lineHeight = $0.setLineHeight(font: .title5_M)
        $0.attributedText = lineHeight
        $0.numberOfLines = 1
        $0.textColor = SacColor.color(.white)
        $0.textAlignment = .center
        $0.font = Font.title5_M12()
        $0.backgroundColor = SacColor.color(.gray7)
    }
    let titleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    // 예외처리, 시작 분기, 이슈 해결 방안
    let bellImage = UIImageView().then {
        $0.image = UIImage(named: "bell")
    }
    let chatTitle = UILabel().then {
        $0.text = "유저와 매칭되었습니다"
        $0.adjustsFontSizeToFitWidth = true
        let lineHeight = $0.setLineHeight(font: .title3_M)
        $0.attributedText = lineHeight
        $0.numberOfLines = 1
        $0.textColor = SacColor.color(.gray7)
        $0.textAlignment = .center
        $0.font = Font.title3_M14()
    }
    let subTitle = UILabel().then {
        $0.text = "채팅을 통해 약속을 정해보세요 :)"
        $0.adjustsFontSizeToFitWidth = true
        let lineHeight = $0.setLineHeight(font: .title4_R)
        $0.attributedText = lineHeight
        $0.numberOfLines = 1
        $0.textColor = SacColor.color(.gray6)
        $0.textAlignment = .center
        $0.font = Font.title4_R14()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setConstraint()
    }
    
    private func setConstraint() {
        addSubview(chatStartDateText)
        addSubview(titleStackView)
        titleStackView.addArrangedSubview(bellImage)
        titleStackView.addArrangedSubview(chatTitle)
        addSubview(subTitle)
        
        chatStartDateText.snp.makeConstraints {
            $0.top.equalTo(self).inset(16)
            $0.centerX.equalTo(self)
            $0.width.equalTo(114)
            $0.height.equalTo(28)
        }
        
        bellImage.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(chatStartDateText.snp.bottom).offset(12)
            $0.centerX.equalTo(self)
            $0.height.equalTo(bellImage)
        }
        subTitle.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(2)
            $0.centerX.equalTo(self)
            $0.height.equalTo(titleStackView)
            $0.bottom.equalTo(self).inset(12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

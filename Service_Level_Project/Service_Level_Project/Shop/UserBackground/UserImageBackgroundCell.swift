//
//  UserImageBackgroundCell.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/15.
//

import UIKit

class UserImageBackgroundCell: UITableViewCell {
    let backgroundImage = UIImageView().then {
        $0.backgroundColor = .gray
    }
    
    let backgroundTitle = UILabel().then {
        $0.text = "하늘 공원"
        let lineHeight = $0.setLineHeight(font: .title3_M)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.black)
        $0.textAlignment = .center
        $0.font = Font.title3_M14()
    }
    let backgroundContent = UILabel().then {
        $0.text = "새싹들을 많이 마주치는 매력적인 하늘 공원입니다"
        let lineHeight = $0.setLineHeight(font: .body3_R)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.black)
        $0.font = Font.body3_R14()
    }
    let backgroundPrice = UILabel().then {
        $0.text = "보유"
        $0.backgroundColor = SacColor.color(.gray2)
        let lineHeight = $0.setLineHeight(font: .title5_M)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.gray7)
        $0.textAlignment = .center
        $0.font = Font.title5_M12()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setConstraints()
    }
    
    private func setConstraints() {
        addSubview(backgroundImage)
//        contentView.addSubview(backgroundTitle)
//        contentView.addSubview(backgroundContent)
//        contentView.addSubview(backgroundPrice)
        
        backgroundImage.snp.makeConstraints { make in
            make.top.equalTo(self).inset(17)
            make.height.equalTo(100)
            make.leading.equalTo(self).inset(17)
            make.bottom.equalTo(self).inset(16)
            make.trailing.equalTo(self.snp.trailing).dividedBy(2.2)
//            make.centerY.equalTo(self)
//            make.height.equalTo(100)
//            make.width.equalTo(self.frame.width * 0.44)
//            make.height.equalTo(100)
        }
        
//        backgroundTitle.snp.makeConstraints { make in
//            make.leading.equalTo(backgroundImage.snp.trailing).offset(12)
//            make.centerY.equalTo(backgroundImage)
////            make.centerY.equalTo(self.snp.centerY).multipliedBy(0.43)
//        }
//        
//        backgroundPrice.snp.makeConstraints { make in
//            make.trailing.equalTo(self).inset(17)
//            make.top.equalTo(backgroundTitle)
//            make.centerY.equalTo(backgroundTitle)
//        }
//        backgroundContent.snp.makeConstraints { make in
//            make.leading.equalTo(backgroundTitle)
//            make.trailing.equalTo(backgroundPrice)
//            make.top.equalTo(backgroundTitle.snp.bottom).offset(8)
//        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

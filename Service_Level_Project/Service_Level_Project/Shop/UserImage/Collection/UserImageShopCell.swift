//
//  UserImageShopCell.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/15.
//

import UIKit

class UserImageShopCell: UICollectionViewCell {
    
    let userImage = UIImageView().then {
        $0.image = SeSacUserImageManager.image(0)
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.layer.borderColor = SacColor.color(.gray2).cgColor
        $0.layer.borderWidth = 1
    }
    
    let userImageTitle = UILabel().then {
        $0.text = "기본 새싹"
        let lineHeight = $0.setLineHeight(font: .title3_M)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.black)
        $0.textAlignment = .center
        $0.font = Font.title3_M14()
    }
    let userImagePrice = UILabel().then {
        $0.text = "보유"
        $0.backgroundColor = SacColor.color(.green)
        let lineHeight = $0.setLineHeight(font: .title5_M)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.white)
        $0.textAlignment = .center
        $0.font = Font.title5_M12()
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    let userImageContent = UILabel().then {
        $0.text = "새싹을 대표하는 기본 식물입니당. 다른 새싹들과 함께하는 것을 좋아합니다"
        let lineHeight = $0.setLineHeight(font: .body3_R)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.black)
        $0.font = Font.body3_R14()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    private func setConstraints() {
        addSubview(userImage)
        addSubview(userImageTitle)
        addSubview(userImagePrice)
        addSubview(userImageContent)
        
        userImage.snp.makeConstraints { make in
            make.top.equalTo(self).inset(8)
            make.leading.trailing.equalTo(self).inset(8)
            make.width.equalTo(self.frame.size.width - 8)
            make.height.equalTo(userImage.snp.width)
        }
        
        userImageTitle.snp.makeConstraints { make in
            make.top.equalTo(userImage.snp.bottom).offset(8)
            make.leading.equalTo(userImage)
        }
        
        userImagePrice.snp.makeConstraints { make in
            make.top.equalTo(userImage.snp.bottom).offset(8)
            make.trailing.equalTo(userImage)
            make.width.equalTo(52)
            make.centerY.equalTo(userImageTitle)
        }
        
        userImageContent.snp.makeConstraints { make in
            make.top.equalTo(userImageTitle.snp.bottom).offset(8)
            make.leading.trailing.equalTo(userImage)
            make.bottom.equalTo(self).inset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  HobbyCollectionCell.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/11.
//

import UIKit

class HobbyCollectionCell: UICollectionViewCell {
    let hobbyButton = ButtonConfiguration(customType: .h32(type: .outline, icon: false)).then {
        $0.setTitle("test", for: .normal)
    }
    let myhobbyButton = ButtonConfiguration(customType: .h32(type: .outline, icon: true))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(hobbyButton)
//        contentView.addSubview(hobbyButton)
//        hobbyButton.snp.makeConstraints {
//            $0.height.equalTo(100)
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

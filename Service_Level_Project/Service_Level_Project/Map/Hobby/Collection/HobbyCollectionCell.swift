//
//  HobbyCollectionCell.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/11.
//

import UIKit

class HobbyCollectionCell: UICollectionViewCell {
    let hobbyButton = ButtonConfiguration(customType: .h32(type: .inactive, icon: false)).then {
        $0.setTitle("test", for: .normal)
    }
    let myhobbyButton = ButtonConfiguration(customType: .h32(type: .outline, icon: true))
    
    func aroundLayoutConfigure(_ indexPath: IndexPath) {
        hobbyButton.layer.borderColor = SacColor.color(.error).cgColor
        hobbyButton.setTitleColor(SacColor.color(.error), for: .normal)
    }
    
    func myselfLayoutConfigure(_ indexPath: IndexPath) {
        // 두번째 변경할 때 여기서 바꾸기
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(hobbyButton)
        contentView.addSubview(myhobbyButton)
        hobbyButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(self)
        }
        myhobbyButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

//
//  MyInfoHeaderView.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/04.
//

import UIKit

class MyInfoHeaderView: UITableViewHeaderFooterView {
    
    let myprofileImage = UIImageView().then {
        $0.image = UIImage(named: "profile_img")
    }
    
    let myprofileName = UILabel().then {
        $0.text = "김새싹"
    }
    
    let myPageButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.tintColor = SacColor.color(.black)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubview(myprofileImage)
        myprofileImage.snp.makeConstraints {
            $0.leading.equalTo(self).inset(17)
            $0.width.equalTo(myprofileImage.snp.height).multipliedBy(1)
            $0.centerY.equalTo(self)
        }
        
        addSubview(myPageButton)
        myPageButton.snp.makeConstraints {
            $0.trailing.equalTo(self).inset(22.5)
            $0.width.equalTo(10)
            $0.centerY.equalTo(self)
        }
        
        addSubview(myprofileName)
        myprofileName.snp.makeConstraints {
            $0.leading.equalTo(myprofileImage.snp.trailing).offset(13)
            $0.trailing.equalTo(myPageButton.snp.leading)
            $0.centerY.equalTo(self)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

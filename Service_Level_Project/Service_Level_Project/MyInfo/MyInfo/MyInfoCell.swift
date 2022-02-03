//
//  MyInfoCell.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/02.
//

import UIKit

class MyInfoCell: UITableViewCell {
    
    lazy var cellImage = UIImageView().then {
        $0.image = UIImage(systemName: "pencil")
    }
    
    lazy var cellTitle = UILabel().then {
        $0.text = "test"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(cellImage)
        addSubview(cellTitle)
        
        setConstraints()
    }
    
    func setConstraints() {
        cellImage.snp.makeConstraints {
            $0.leading.equalTo(self).inset(17)
            $0.centerY.equalTo(self)
        }
        
        cellTitle.snp.makeConstraints {
            $0.leading.equalTo(cellImage.snp.trailing).offset(10)
            $0.centerY.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

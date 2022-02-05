//
//  MyInfoHeaderView.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/04.
//

import UIKit

class MyInfoHeaderView: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = .brown
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .brown
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

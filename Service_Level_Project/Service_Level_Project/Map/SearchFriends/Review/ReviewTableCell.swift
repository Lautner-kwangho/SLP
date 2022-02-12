//
//  ReViewTableCell.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/13.
//

import UIKit

class ReviewTableCell: UITableViewCell {

    let review = UITextView().then {
        $0.text = "리뷰 들어가지요"
        $0.textColor = SacColor.color(.black)
        $0.font = Font.body3_R14()
        $0.isScrollEnabled = false
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(review)
        review.snp.makeConstraints {
            $0.edges.equalTo(self).inset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  Custom+View.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/06.
//

import UIKit

class DimensionHeaderView: UIView {
    
    //MARK: 오토디멘션 스택뷰 정보
    let dimensionStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.spacing = 24
    }
    let sesacTitleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 16
    }
    let hobbyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 16
    }
    let sesacReviewStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 16
    }
    
    
    //MARK: 오토디멘션 정보
    let userNickname = UILabel().then {
        $0.text = "김새싹"
        let lineHeight = $0.setLineHeight(font: .title1_M)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.black)
        $0.textAlignment = .left
        $0.font = Font.title1_M16()
    }
    let sesacTitle = UILabel().then {
        $0.text = "새싹 타이틀"
        let lineHeight = $0.setLineHeight(font: .title6_R)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.black)
        $0.textAlignment = .left
        $0.font = Font.title6_R12()
    }
    let userTitleButton = ButtonCollection(isEnable: false)
    
    // 하고 싶은 취미
    let hobby = UILabel().then {
        $0.text = "하고 싶은 취미"
        let lineHeight = $0.setLineHeight(font: .title6_R)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.black)
        $0.textAlignment = .left
        $0.font = Font.title6_R12()
    }
    let hobbyListStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 8
    }
    
    let sesacReview = UILabel().then {
        $0.text = "새싹 리뷰"
        let lineHeight = $0.setLineHeight(font: .title6_R)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.black)
        $0.textAlignment = .left
        $0.font = Font.title6_R12()
    }
    let userReview = UILabel().then {
        $0.text = "첫 리뷰를 기다리는 중이에요"
        let lineHeight = $0.setLineHeight(font: .body3_R)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.gray6)
        $0.textAlignment = .left
        $0.font = Font.body3_R14()
    }
    let emptySpace = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        
        self.layer.borderWidth = 1
        self.layer.borderColor = SacColor.color(.gray2).cgColor
        self.layer.cornerRadius = 15
    }
    
    private func setConstraints() {
        
        // 큰 틀 스택뷰
        addSubview(dimensionStackView)
        dimensionStackView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        dimensionStackView.addArrangedSubview(userNickname)
        dimensionStackView.addArrangedSubview(sesacTitleStackView)
        dimensionStackView.addArrangedSubview(hobbyStackView)
        dimensionStackView.addArrangedSubview(sesacReviewStackView)
        dimensionStackView.addArrangedSubview(emptySpace)
        
        // 세부 종류 스택뷰
        sesacTitleStackView.addArrangedSubview(sesacTitle)
        sesacTitleStackView.addArrangedSubview(userTitleButton)
        
        hobbyStackView.addArrangedSubview(hobby)
        hobbyStackView.addArrangedSubview(hobbyListStackView)
        
        sesacReviewStackView.addArrangedSubview(sesacReview)
        sesacReviewStackView.addArrangedSubview(userReview)
        
        [sesacTitle, hobby, sesacReview, userReview].forEach {
            $0.snp.makeConstraints { make in
                make.leading.trailing.equalTo(dimensionStackView).inset(16)
            }
        }
        
        userNickname.snp.makeConstraints {
            $0.leading.trailing.equalTo(dimensionStackView).inset(16)
            $0.height.equalTo(58)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

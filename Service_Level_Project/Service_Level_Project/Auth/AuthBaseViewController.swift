//
//  AuthBaseViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/21.
//

import UIKit

class AuthBaseViewController: BaseViewController {
    
    var firstLabel = UILabel().then {
        $0.text = "첫줄 텍스트가 들어갑니다"
        let lineHeight = $0.setLineHeight(font: .display1_R)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.black)
        $0.textAlignment = .center
        $0.font = Font.display1_R20()
    }
    var secondLabel = UILabel().then {
//        $0.text = "세컨드 레이블 입니다"
        let lineHeight = $0.setLineHeight(font: .title2_R)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.gray7)
        $0.textAlignment = .center
        $0.font = Font.title2_R16()
    }
    var middleView = UIView()
    
    var customButton = ButtonConfiguration(customType: .h48(type: .disable, icon: false)).then {
        $0.setTitle("인증 번호 받기", for: .normal)
        $0.isEnabled = false
    }
    
    let deviceHeight = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
//        super.viewDidLoad()
        view.backgroundColor = SacColor.color(.white)
        setConstraints()
        configure()
    }
    
    override func setConstraints() {
        let topInset = deviceHeight * 0.2
        let bottomInset = deviceHeight * 0.42
        
        view.addSubview(firstLabel)
        firstLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(topInset)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        view.addSubview(secondLabel)
        secondLabel.snp.makeConstraints {
            $0.top.equalTo(firstLabel.snp.bottom)
            $0.leading.trailing.equalTo(firstLabel)
        }
        
        view.addSubview(customButton)
        customButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(bottomInset)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        view.addSubview(middleView)
        middleView.snp.makeConstraints {
            $0.top.equalTo(secondLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customButton.snp.top)
        }
        

    }
}

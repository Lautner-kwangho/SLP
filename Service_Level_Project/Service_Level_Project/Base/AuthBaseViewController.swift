//
//  AuthBaseViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/21.
//

import UIKit

class AuthBaseViewController: BaseViewController {
    
    var firstLabel = UILabel().then {
        $0.setLineHeight(font: .display1_R)
        $0.font = Font.display1_R20()
        $0.text = "첫줄 텍스트가 들어갑니다\neee"
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.black)
        $0.textAlignment = .center
        $0.backgroundColor = .brown
    }
    var secondLabel = UILabel()
    let middleView = UIView()
    let customButton = UIButton()
    
    let deviceHeight = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SacColor.color(.white)
        setConstraints()
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
        
        
        view.addSubview(middleView)
        
        
        view.addSubview(customButton)
        

    }
}

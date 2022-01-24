//
//  AuthPhoneMessageViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/24.
//

import UIKit

class AuthPhoneMessageViewController: AuthBaseViewController {
    let messageField = InputText(type: .inative).then {
        $0.textField.placeholder = "인증번호 입력"
        $0.textField.keyboardType = .phonePad
    }
    let sendButton = ButtonConfiguration(customType: .h40(type: .disable, icon: false)).then {
        $0.setTitle("재전송", for: .normal)
    }
    let secondCountLabel = UILabel().then {
        $0.font = Font.title3_M14()
        $0.textColor = SacColor.color(.green)
    }
    
    let viewModel = AuthPhoneMessageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        viewModel.countSecond()
        viewModel.setmessageField(messageField, sendButton, customButton)
        
        firstLabel.text = viewModel.firstText
        secondLabel.text = viewModel.secondText
        customButton.setTitle(viewModel.buttonTitle, for: .normal)
        viewModel.secondCount.asObserver().bind(onNext: { time in
            self.secondCountLabel.text = time
        })
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
            $0.top.equalTo(firstLabel.snp.bottom).offset(8)
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
        
        middleView.addSubview(sendButton)
        sendButton.snp.makeConstraints {
            $0.centerY.equalTo(middleView)
            $0.trailing.equalTo(middleView).inset(16)
            $0.width.equalTo(view.frame.width * 0.2)
        }
        
        middleView.addSubview(messageField)
        messageField.snp.makeConstraints {
            $0.centerY.equalTo(middleView)
            $0.leading.equalTo(middleView).inset(16)
            $0.trailing.equalTo(sendButton.snp.leading).inset(-8)
        }
        
        middleView.addSubview(secondCountLabel)
        secondCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(messageField.textField)
            $0.trailing.equalTo(sendButton.snp.leading).inset(-20)
        }
    
    }
}

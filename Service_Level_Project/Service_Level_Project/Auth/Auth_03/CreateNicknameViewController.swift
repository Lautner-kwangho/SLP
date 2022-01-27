//
//  CreateNicknameViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/25.
//

import UIKit
import Firebase

class CreateNicknameViewController: AuthBaseViewController {
    
    let nicknameTextField = InputText(type: .inative).then {
        $0.textField.placeholder = "10자 이내로 입력"
    }
    
    let viewModel = CreateNicknameViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nickname = UserDefaults.standard.string(forKey: "nickname")
        guard let nickname = nickname else { return }
        nicknameTextField.textField.text = nickname
    }
    
    override func configure() {
        firstLabel.text = viewModel.Title
        customButton.setTitle(viewModel.customButtonTitle, for: .normal)
        
        viewModel.setUI(self, nicknameTextField, customButton) { text in
            if text.count > 0 {
                self.nicknameTextField.statusText.onNext(.focus)
                self.customButton.isEnabled = true
                buttonCase.customLayout(self.customButton, .fill)
            } else {
                self.nicknameTextField.statusText.onNext(.inative)
                self.customButton.isEnabled = false
                buttonCase.customLayout(self.customButton, .disable)
            }
        }
        // 여기 수정한다 하면
        // input output도 쓰기
 
        customButton.rx.tap.asDriver()
            .drive(onNext: { _ in
                viewModel.
            })
            .disposed(by: disposeBag)
        viewModel.nextButtonClicked(self, customButton)
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
        
        middleView.addSubview(nicknameTextField)
        nicknameTextField.snp.makeConstraints {
            $0.centerY.equalTo(middleView)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

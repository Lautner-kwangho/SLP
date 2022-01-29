//
//  CreateNicknameViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/25.
//

import UIKit
import RxSwift
import Firebase

class CreateNicknameViewController: AuthBaseViewController {
    
    let nicknameTextField = InputText(type: .inactive).then {
        $0.textField.placeholder = "10자 이내로 입력"
    }
    
    private lazy var input = CreateNicknameViewModel
        .Input(
            inputNickname: nicknameTextField.textField.rx.text.orEmpty.asDriver()
//            buttonTapEvent: customButton.rx.tap.asSignal()
        )
    private lazy var output = viewModel.transform(input: input)
    
    private let viewModel = CreateNicknameViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nickname = UserDefaults.standard.string(forKey: "nickname")
        guard let nickname = nickname else { return }
        nicknameTextField.textField.text = nickname
    }
    
    private func bind() {
        // test
        output.outputNickname.drive(onNext: { [weak self] text in
            print(text)
        }).disposed(by: disposeBag)
        
        output.nicknameUIStatus.drive(onNext: { [weak self] stauts in
            guard let self = self else {return}
            if stauts {
                self.nicknameTextField.statusText.onNext(.focus)
                self.customButton.isEnabled = stauts
                self.customButton.customLayout(.fill)
            } else {
                self.nicknameTextField.statusText.onNext(.inactive)
                self.customButton.isEnabled = stauts
                self.customButton.customLayout(.disable)
            }
        }).disposed(by: disposeBag)
        
        customButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else {return}
                guard let text = self.nicknameTextField.textField.text else { return }
                if text.count > 10 {
                    self.view.makeToast("10자 이하로 입력해주세요", position: .center)
                } else {
                    UserDefaults.standard.set(text,forKey: "nickname")
                    self.navigationController?.pushViewController(BirthdayViewController(), animated: true)
            
                }
            }.disposed(by: disposeBag)
        
//        output.sendToastMessage.drive(onNext: { text in
//            self.view.makeToast(text)
//        }).disposed(by: disposeBag)
        
    }
             
    
    override func configure() {
        firstLabel.text = viewModel.Title
        customButton.setTitle(viewModel.customButtonTitle, for: .normal)
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

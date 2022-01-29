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
            inputNickname: nicknameTextField.textField.rx.text.orEmpty.asDriver(),
            buttonTapEvent: customButton.rx.tap.asSignal()
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
        
        output.nextButtonClicked
            .drive(onNext: { status in
            if status {
                print("투루로 넘겨줌")
//                self.output.outputNickname.drive(onNext: { text in
//                    print("유저디폴투",text)
//                })
                self.view.makeToast("토스트 띄어줄거임", position: .center)
            } else {
                print("폴스로 넘겨줌")
            }
        }).disposed(by: disposeBag)
        
        // button.rx.tap.map {
//        weak self. selftextfield.text) .asDriver()
//    }
//        output.sendToastMessage.drive(onNext: { message in
//            self.view.makeToast(message, position: .center)
//        }).disposed(by: disposeBag)
        
        
        
//        UserDefaults.standard.set(text,forKey: "nickname")
//        vc.navigationController?.pushViewController(BirthdayViewController(), animated: true)
        
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

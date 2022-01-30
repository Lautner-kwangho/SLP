//
//  EmailViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/25.
//

import UIKit
import RxSwift

class EmailViewController: AuthBaseViewController {
    
    let emailTextField = InputText(type: .inactive).then {
        $0.textField.placeholder = "SeSAC@gmail.com"
        $0.textField.keyboardType = .emailAddress
    }
    
    private lazy var input = EmailViewModel
        .Input(
            emailTextField: emailTextField.textField.rx.text.orEmpty.asDriver(),
            userDefaultsIsSave: UserDefaults.standard.string(forKey: "email")
        )
    private lazy var output = viewModel.transform(input: input)
    
    var viewModel = EmailViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.savedEmailNotEmpty
            .distinctUntilChanged()
            .asSignal()
            .emit(onNext: { [weak self] text in
                guard let self = self else {return}
                self.emailTextField.textField.text = text
                self.emailTextField.statusText.onNext(.inactive)
                self.customButton.isEnabled = true
                self.customButton.customLayout(.fill)
            })
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        
        output.configurationCheckStatus
            .drive(onNext: { [weak self] status in
                guard let self = self else {return}
                if status {
                    self.emailTextField.statusText.onNext(.success)
                    self.customButton.isEnabled = status
                    self.customButton.customLayout(.fill)
                } else {
                    self.emailTextField.statusText.onNext(.error)
                    self.customButton.isEnabled = status
                    self.customButton.customLayout(.disable)
                }
            })
            .disposed(by: disposeBag)
        
        customButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else {return}
                UserDefaults.standard.set(self.viewModel.email, forKey: "email")
                self.navigationController?.pushViewController(SelectGenderViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func configure() {
        firstLabel.text = viewModel.Title
        secondLabel.text = viewModel.subTItle
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
        
        middleView.addSubview(emailTextField)
        emailTextField.snp.makeConstraints {
            $0.centerY.equalTo(middleView)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

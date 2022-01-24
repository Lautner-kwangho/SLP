//
//  AuthPhoneViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/24.
//

import UIKit
import RxSwift

class AuthPhoneViewController: AuthBaseViewController {

    var inputPhoneNumber = InputText(type: .inative).then {
        $0.textField.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        $0.textField.keyboardType = .phonePad
    }
    
    let disposBag = DisposeBag()
    let viewModel = AuthPhoneViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        firstLabel.text = viewModel.titleName
        inputPhoneNumber.textField.delegate = self
        
        viewModel.phoneText.bind { value in
            if self.inputPhoneNumber.textField.isEditing {
                let type = value.count > 0 ? inputTextCase.focus : inputTextCase.active
                self.inputPhoneNumber.statusText.onNext(type)
            }
        }.disposed(by: disposBag)
        // text 가져넣기
        viewModel.setInputTextPhoneNumber(inputPhoneNumber, customButton)
        
        // 버튼 처리
        viewModel.setButtonSetting(customButton)
        
        // 정규식 적용
        viewModel.textFieldRegex()
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
        
        middleView.addSubview(inputPhoneNumber)
        inputPhoneNumber.snp.makeConstraints {
            $0.centerY.equalTo(middleView)
            $0.leading.trailing.equalTo(middleView).inset(16)
        }
    }
}

extension AuthPhoneViewController: UITextFieldDelegate {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputPhoneNumber.statusText.onNext(.active)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        let newText = (text as NSString).replacingCharacters(in: range, with: string)
        if text.count > 2 {
            let number = text[text.index(text.startIndex, offsetBy: 2)]
            let pattern = number == "1" ? "XXX-XXX-XXXX" : "XXX-XXXX-XXXX"
            
            textField.text = format(with: pattern, phone: newText)
            viewModel.phoneText.onNext(format(with: pattern, phone: newText))
            return false
        } else {
            return true
        }
//        let characters: CharacterSet = {
//            var set = CharacterSet.lowercaseLetters
//            set.insert(charactersIn: "0123456789")
//            return set.inverted
//        }()
    
//        if (textField.text?.count)! > 13 {
//            textField.text!.removeLast()
//            return false
//        }
        
//        if string.count > 0 {
//            guard string.rangeOfCharacter(from: characters) == nil else {
//                return false }
//        }
        
//        return true
    }
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        for str in mask where index < numbers.endIndex {
            if str == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(str)
            }
        }
        return result
    }
    
    
}

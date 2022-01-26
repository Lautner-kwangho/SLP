//
//  AuthPhoneViewModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/24.
//

import UIKit
import Firebase
import RxSwift

class AuthPhoneViewModel {
    var phoneText = BehaviorSubject<String>(value: "")
    var phoneTest = BehaviorSubject<String>(value: "")
    let disposeBag = DisposeBag()
    
    let inputText = InputText()
    let titleName = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해주세요"
    
    func setInputTextPhoneNumber(_ view: InputText, _ button: UIButton) {
        
        view.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind { value in
                self.phoneText.onNext(value)
            }
            .disposed(by: disposeBag)
        
        phoneTest.bind { validText in
            if validText == "맞음" {
                view.statusText.onNext(.success)
                button.isEnabled = true
                buttonCase.customLayout(button, .fill)
            } else if validText == "안맞음" {
                view.statusText.onNext(.error)
                button.isEnabled = false
                buttonCase.customLayout(button, .disable)
            }
        }.disposed(by: disposeBag)
        
    }
    
    func textFieldRegex() {
        // 전화번호 정규식
        // let pattern = "^01[0-1][0-9]{7,8}$"
        
        phoneText.bind { text in
            if text.count > 2 {
                let number = text[text.index(text.startIndex, offsetBy: 2)]
                let pattern = number == "1" ? "^01[0-1][-][0-9]{3}[-][0-9]{4}$" : "^01[0-1][-][0-9]{4}[-][0-9]{4}$"
                let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
                let phoneNumberTest = predicate.evaluate(with: text)
                if phoneNumberTest {
                    self.phoneTest.onNext("맞음")
                } else {
                    self.phoneTest.onNext("안맞음")
                }
            }
        }.disposed(by: disposeBag)
        
    }
    
    func clickedButton(_ vc: UIViewController) {
        phoneText.subscribe { text in
            let phoneNumber = "+82" + text
            Auth.auth().languageCode = "ko-KR"
            
            PhoneAuthProvider
                .provider()
                .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                    if let error = error {
                        // 이렇게 두개 뜨는데 애초에 번호를 잘못 넣을 수 없으니까 처리 안해줘도 되지 않을까 싶은데
                        // User interaction is still ongoing, another view cannot be presented.
                        //The interaction was cancelled by the user
                        // print("사용자 에러", error.localizedDescription)
                        return
                    }
                    UserDefaults.standard.removeObject(forKey: "idToken")
                    UserDefaults.standard.removeObject(forKey: "PhoneNumber")
                    guard let verificationID = verificationID else { return }
                    UserDefaults.standard.set(verificationID, forKey: "idToken")
                    UserDefaults.standard.set(phoneNumber, forKey: "PhoneNumber")
                    if verificationID != "" {
                        DispatchQueue.main.async {
                            vc.navigationController?.pushViewController(AuthPhoneMessageViewController(), animated: true)
                        }
                    }
                }
        } onError: { error in
            print(error)
        }.disposed(by: disposeBag)

    }
    
}

//
//  AuthPhoneMessageViewModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/24.
//

import UIKit
import Firebase
import RxSwift

class AuthPhoneMessageViewModel {
    
    var messageText = BehaviorSubject<String>(value: "")
    var secondCount = BehaviorSubject<String>(value: "")
    
    let disposeBag = DisposeBag()
    
    let fcmToken = UserDefaults.standard.string(forKey: "FCMID")
    let phoneNumber = UserDefaults.standard.string(forKey: "PhoneNumber")
    
    var count = 60
    
    let firstText = "인증번호가 문자로 전송되었어요"
    let secondText = "(최대 소모 20초)"
    let buttonTitle = "인증하고 시작하기"
    
    func setmessageField(_ vc: UIViewController, _ view: InputText,_ resendButton: UIButton, _ authButton: UIButton) {
        view.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind { value in
                self.messageText.onNext(value)
                if value.count > 5 {
                    authButton.isEnabled = true
                    buttonCase.customLayout(authButton, .fill)
                } else {
                    authButton.isEnabled = false
                    buttonCase.customLayout(authButton, .disable)
                }
            }
            .disposed(by: disposeBag)
        
        authButton.addTarget(self, action: #selector(authButtonClicked), for: .touchUpInside)
        
        vc.view.makeToast("인증번호를 보냈습니다")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            resendButton.isEnabled = true
            buttonCase.customLayout(resendButton, .fill)
        }
        
        resendButton.rx.tap
            .map { vc.view.makeToast("", duration: 0.5, title:"잠시만 기다려주세요")}
            .debounce(RxTimeInterval.seconds(5), scheduler: MainScheduler.instance)
            .subscribe(onNext: { value in
                vc.view.makeToast("재전송했습니다")
                self.count = 60
                
                guard let phoneNumber = self.phoneNumber else { return }

                Auth.auth().languageCode = "ko-KR"
                
                PhoneAuthProvider
                    .provider()
                    .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                        if let error = error {
                            print("폰 에러", error.localizedDescription)
                            return
                        }
                        guard let verificationID = verificationID else { return }
                        UserDefaults.standard.removeObject(forKey: "FCMID")
                        UserDefaults.standard.set(verificationID, forKey: "FCMID")
                    }
            },onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    @objc func authButtonClicked() {
        self.messageText
            .distinctUntilChanged()
            .subscribe(onNext: { text in
                guard let fcmID = self.fcmToken else { return }
                
                let credential = PhoneAuthProvider.provider().credential(
                    withVerificationID: fcmID,
                    verificationCode: text
                )
                
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        let authError = error as NSError
                        if authError.code == AuthErrorCode.secondFactorRequired.rawValue {
                            let resolver = authError.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
                            var displayNameString = ""
                            for tmpFactorInfo in resolver.hints {
                                displayNameString += tmpFactorInfo.displayName ?? ""
                                displayNameString += " "
                            }
                        }
                        return
                    }
                    // User is Signed in
                    print(authResult?.user.uid)
                    
                }
                
            }, onError: { error in
                print("인증 에러", error)
            }).disposed(by: disposeBag)
    }
    
    func countSecond(_ vc: UIViewController) {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { time in
            if self.count != 0 {
                self.count -= 1
                let minute = self.count / 60
                let second = self.count % 60

                let timer = second < 10 ? "0\(minute):0\(second)" : "0\(minute):\(second)"
                self.secondCount.onNext(timer)
            } else {
                time.invalidate()
                vc.view.makeToast("전화번호 인증 실패")
            }
        }
    }
}

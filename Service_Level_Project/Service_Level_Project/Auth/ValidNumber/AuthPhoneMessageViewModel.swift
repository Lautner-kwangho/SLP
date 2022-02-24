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
    
    let idToken = UserDefaults.standard.string(forKey: UserDefaultsManager.idToken)
    let phoneNumber = UserDefaults.standard.string(forKey: UserDefaultsManager.phoneNumber)
    
    var count = 60
    
    let firstText = "인증번호가 문자로 전송되었어요"
    let secondText = "(최대 소모 20초)"
    let buttonTitle = "인증하고 시작하기"
    
    func setmessageField(_ vc: UIViewController, _ view: InputText,_ resendButton: ButtonConfiguration, _ authButton: ButtonConfiguration) {
        view.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind { value in
                self.messageText.onNext(value)
                if value.count == 6 {
                    authButton.isEnabled = true
                    authButton.customLayout(.fill)
                } else {
                    authButton.isEnabled = false
                    authButton.customLayout(.disable)
                }
            }
            .disposed(by: disposeBag)
        
        vc.view.makeToast("인증번호를 보냈습니다")
        
        secondCount
            .subscribe(onNext: { text in
                if text == "00:00" {
                    authButton.isEnabled = false
                    authButton.customLayout(.disable)
                }
            })
            .disposed(by: disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            resendButton.isEnabled = true
            resendButton.customLayout(.fill)
        }
        
        resendButton.rx.tap
            .map { vc.view.makeToast("", duration: 0.5, title:"잠시만 기다려주세요")}
            .debounce(RxTimeInterval.seconds(5), scheduler: MainScheduler.instance)
            .subscribe(onNext: { value in
                guard let phoneNumber = self.phoneNumber else { return }

                Auth.auth().languageCode = "ko-KR"
                
                PhoneAuthProvider
                    .provider()
                    .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                        if let error = error {
                            return
                        }
                        guard let verificationID = verificationID else { return }
                        UserDefaults.standard.removeObject(forKey: UserDefaultsManager.idToken)
                        UserDefaults.standard.set(verificationID, forKey: UserDefaultsManager.idToken)
                        self.count = 60
                        self.countSecond(vc)
                        vc.view.makeToast("재전송했습니다")
                    }
                
            },onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    func authButtonClicked(_ button: UIButton, _ vc: UIViewController) {
        var number = ""
        self.messageText
            .distinctUntilChanged()
            .subscribe(onNext: { text in
                number = text
            }, onError: { error in
                print("인증 에러", error)
            }).disposed(by: self.disposeBag)
        
        button.rx.tap.asDriver()
            .drive(onNext: { _ in
                guard let idToken = self.idToken else { return }
                
                let credential = PhoneAuthProvider.provider().credential(
                    withVerificationID: idToken,
                    verificationCode: number
                )
                
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        let authError = error as NSError
                        print("에러 코드 발생",authError.code)
                        
                        let errorText = AuthError.authCheckError(authError.code)
                        vc.view.makeToast(errorText)
                        
                        return
                    }
                    // User is Signed in
                    guard let authResult = authResult else {return}
                    
                    DispatchQueue.global().sync {
                    
                        let currentUser = Auth.auth().currentUser
                        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                            guard let idToken = idToken else { return }
                            UserDefaults.standard.set(idToken, forKey: UserDefaultsManager.authIdToken)
                            UserDefaults.standard.set(true, forKey: UserDefaultsManager.onboarding)
                        }
                    
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                        windowScene.windows.first?.makeKeyAndVisible()
                        SeSacURLNetwork.shared.loginMember { data in
                            windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: MyInfoViewController())
                        } failErrror: { error in
                            windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: CreateNicknameViewController())
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
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

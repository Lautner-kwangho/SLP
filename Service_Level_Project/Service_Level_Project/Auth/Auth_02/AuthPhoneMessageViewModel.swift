//
//  AuthPhoneMessageViewModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/24.
//

import UIKit
import RxSwift

class AuthPhoneMessageViewModel {
    
    var secondCount = BehaviorSubject<String>(value: "")
    let disposeBag = DisposeBag()
    
    var count = 60
    
    let firstText = "인증번호가 문자로 전송되었어요"
    let secondText = "(최대 소모 20초)"
    let buttonTitle = "인증하고 시작하기"
    
    func setmessageField(_ view: InputText,_ resendButton: UIButton, _ authButton: UIButton) {
        view.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind { value in
                print(value)
                if value.count > 0 {
                    authButton.isEnabled = true
                    buttonCase.customLayout(authButton, .fill)
                } else {
                    authButton.isEnabled = false
                    buttonCase.customLayout(authButton, .disable)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func countSecond() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { time in
            if self.count != 0 {
                self.count -= 1
                let minute = self.count / 60
                let second = self.count % 60

                let timer = second < 10 ? "0\(minute):0\(second)" : "0\(minute):\(second)"
                self.secondCount.onNext(timer)
            } else {
                time.invalidate()
            }
        }
    }
}

//
//  EmailViewModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/25.
//

import UIKit
import RxSwift

class EmailViewModel {
    
    let Title = "이메일을 입력해주세요"
    let subTItle = "휴대폰 번호 변경 시 인증을 위해 사용해요"
    let customButtonTitle = "다음"
    var email = ""
    
    let disposeBag = DisposeBag()
    
    func savedEmail(_ textField: InputText, _ button: UIButton) {
        let email = UserDefaults.standard.string(forKey: "email")
        guard let email = email else { return }
        
        textField.textField.text = email
        button.isEnabled = true
        buttonCase.customLayout(button, .fill)
    }
    func setTextField(_ textField: InputText, _ button: UIButton) {
        textField.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind { text in
                self.email = text
                /*
                 let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}" 이렇게 사용하면 맨뒤에 co만 되어도 맞다고 나옴 그래서 안됨
                 + gmail 만들 때는 소문자 . 숫자만 됨
                "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2}[A-Za-z]{1}$" 이렇게 해주면 되긴 할텐데 만약에 학교나 기업 계정으로 사용하면? 어떻게 할래... 그 계정들은 ~~@kw.ac.kr이런 식일 텐데?
                "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2}[A-Za-z]*$" 이렇게 하면 com이나 net같은 걸로 가능 (기업이나 학교는 생각해봐야할 듯)
                 
                 => 팀빌딩 결론: 이건 기획에서 정해줘야 한다 !!!!!!!!!!!!!!!!!!
                 */
                if text.count > 0 {
                    let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2}[A-Za-z]{1}$"
                    let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
                    let emailTest = predicate.evaluate(with: self.email)
                    if emailTest {
                        textField.statusText.onNext(.success)
                        button.isEnabled = true
                        buttonCase.customLayout(button, .fill)
                    } else {
                        textField.statusText.onNext(.error)
                        button.isEnabled = false
                        buttonCase.customLayout(button, .disable)
                    }
                } else {
                    textField.statusText.onNext(.inative)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func clickedEmailButton(_ vc: UIViewController,_ button: UIButton) {
        button.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                let email = UserDefaults.standard.string(forKey: "email")
                if email == nil {
                    UserDefaults.standard.set(self.email, forKey: "email")
                }
                vc.navigationController?.pushViewController(SelectGenderViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}

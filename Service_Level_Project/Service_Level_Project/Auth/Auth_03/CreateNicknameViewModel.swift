//
//  CreateNicknameViewModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/25.
//

import UIKit
import RxSwift
import Toast

class CreateNicknameViewModel {
    
    var nickname = BehaviorSubject<String>(value: "")
    let disposeBag = DisposeBag()
    let style = ToastStyle()
    
    let Title = "닉네임을 입력해주세요"
    let customButtonTitle = "다음"
    
    func setUI(_ vc: UIViewController, _ view: InputText, _ nextButton: UIButton) {
        // 텍스트 넘겨주기
        view.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind { text in
                self.nickname.onNext(text)
            }.disposed(by: disposeBag)
        
        // 텍스트 넘겨받기
        nickname.bind { text in
            if text.count > 0 {
                buttonCase.customLayout(nextButton, .fill)
            } else {
                buttonCase.customLayout(nextButton, .disable)
            }
        }.disposed(by: disposeBag)
    }
    
    
    func nextButtonClicked(_ vc: UIViewController, _ nextButton: UIButton) {
        nextButton.rx.tap
            .bind { value in
                print("clicked")
                self.validButton(vc)
            }
            .disposed(by: disposeBag)
    }
    
    func validButton(_ vc: UIViewController) {
        self.nickname.bind { text in
            print(text)
            if text.count == 0 || text.count > 10 {
                vc.view.makeToast("", duration: 1, position: .center, title: "qq", style: self.style, completion: nil)
            }
        }
        .disposed(by: disposeBag)
    }
    
}

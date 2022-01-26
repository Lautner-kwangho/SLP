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
        nickname
            .distinctUntilChanged()
            .bind { text in
            if text.count > 0 {
                view.statusText.onNext(.active)
                nextButton.isEnabled = true
                buttonCase.customLayout(nextButton, .fill)
            } else {
                view.statusText.onNext(.inative)
                nextButton.isEnabled = false
                buttonCase.customLayout(nextButton, .disable)
            }
        }.disposed(by: disposeBag)
    }
    
    
    func nextButtonClicked(_ vc: UIViewController, _ nextButton: UIButton) {
        print(11)
        // 클릭할 때마다 구독이생기는 거니까 밑에 다음 버튼에서 자꾸... 여러개가 뜨지...
        // 이거 수정
        nextButton.rx.tap
            .bind { value in
                print("clicked")
                self.validButton(vc)
            }
            .disposed(by: disposeBag)
    }
    
    func validButton(_ vc: UIViewController) {
        var nicknameValid = ""
        self.nickname
            .distinctUntilChanged()
            .bind { text in
                nicknameValid = text
        }
        .disposed(by: disposeBag)
        
        if nicknameValid.count == 0 || nicknameValid.count > 10 {
            vc.view.makeToast("", duration: 1, position: .center, title: "닉네임은 1자 이상 10자 이내로 부탁드려요.", style: self.style, completion: nil)
        }
    }
    
}

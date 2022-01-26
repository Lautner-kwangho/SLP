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
    
    func setUI(_ vc: UIViewController, _ view: InputText, _ nextButton: UIButton, _ completion: @escaping (String) -> ()) {
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
                completion(text)
        }.disposed(by: disposeBag)
    }
    
    
    func nextButtonClicked(_ vc: UIViewController, _ nextButton: UIButton) {
        print(11)
        // 클릭할 때마다 구독이생기는 거니까 밑에 다음 버튼에서 자꾸... 여러개가 뜨지...
        // 이거 수정
        nextButton.rx.tap
            .asDriver()
            .drive { value in
                self.validButton(vc) { text in
                    if text != "올바르지 않음" {
                        UserDefaults.standard.set(text,forKey: "nickname")
                        vc.navigationController?.pushViewController(BirthdayViewController(), animated: true)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    func validButton(_ vc: UIViewController, nickname: @escaping (String) -> Void) {
        var nicknameValid = ""
        // 금지 닉네임: 바람의나라, 미묘한도사, 고래밥
        self.nickname
            .distinctUntilChanged()
            .bind { text in
                nicknameValid = text
        }
        .disposed(by: disposeBag)
        
        if nicknameValid.count == 0 || nicknameValid.count > 10 {
            vc.view.makeToast("", duration: 1, position: .center, title: "닉네임은 1자 이상 10자 이내로 부탁드려요.", style: self.style, completion: nil)
            nickname("올바르지 않음")
        } else {
            nickname(nicknameValid)
        }
    }
    
}

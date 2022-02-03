//
//  EmailViewModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/25.
//

import Foundation

import RxSwift
import RxCocoa
import RxRelay

class EmailViewModel: BaseViewModel {
    
    //MARK: Inputm Output
    struct Input {
        let emailTextField: Driver<String>
        let userDefaultsIsSave: String?
    }
    
    struct Output {
        let configurationCheckStatus: Driver<Bool>
        let savedEmailNotEmpty: Signal<String>
    }
    
    private let configurationCheckStatus = BehaviorRelay<Bool>(value: false)
    private let savedEmailNotEmpty = BehaviorRelay<String>(value: "")
    
    var disposeBag = DisposeBag()
    
    //MARK: Transform(input:)
    func transform(input: Input) -> Output {
        
        input.emailTextField
            .distinctUntilChanged()
            .drive(onNext: { text in
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
                    self.configurationCheckStatus.accept(emailTest)
                }
            })
            .disposed(by: disposeBag)
    
        if let text = input.userDefaultsIsSave {
            self.savedEmailNotEmpty.accept(text)
            self.email = text
        }
        
        return Output(configurationCheckStatus: configurationCheckStatus.asDriver(), savedEmailNotEmpty: savedEmailNotEmpty.asSignal(onErrorJustReturn: ""))
    }
    
    //MARK: 기본 텍스트 입력
    let Title = "이메일을 입력해주세요"
    let subTItle = "휴대폰 번호 변경 시 인증을 위해 사용해요"
    let customButtonTitle = "다음"
    var email = ""
    
}

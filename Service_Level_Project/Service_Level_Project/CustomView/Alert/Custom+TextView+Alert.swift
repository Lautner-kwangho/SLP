//
//  Custom+TextView+Alert.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/15.
//

import UIKit
import RxSwift

class SeSacTextViewAlert: BaseViewController {
    
    let alertView = UIView().then {
        $0.backgroundColor = SacColor.color(.white)
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    let alertTitle = UILabel().then {
        let lineHeight = $0.setLineHeight(font: .body1_M)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.adjustsFontSizeToFitWidth = true
        $0.textColor = SacColor.color(.black)
        $0.textAlignment = .center
        $0.font = Font.body1_M16()
    }
    
    let cancelButton = UIButton().then {
        $0.setImage(UIImage(named: "close_small"), for: .normal)
    }
    
    let alertContent = UILabel().then {
        let lineHeight = $0.setLineHeight(font: .title4_R)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.green)
        $0.textAlignment = .center
        $0.font = Font.title4_R14()
    }
    
    let alartReviewButton = ButtonCollection(isEnable: true)
    let alertSignButton = ButtonSignCollection(isEnable: true)
    
    let signTextview = UITextView().then {
        $0.text = "신고 사유를 적어주세요\n허위 신고 시 제재를 받을 수 있습니다"
        $0.backgroundColor = SacColor.color(.gray1)
        $0.layer.cornerRadius = 8
        $0.font = Font.body3_R14()
        $0.textColor = SacColor.color(.gray7)
        $0.contentInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
    }
    
    let submitButton = ButtonConfiguration(customType: .h48(type: .disable, icon: false)).then {
        $0.setTitle("확인", for: .normal)
        $0.isEnabled = false
    }
    
    var placeholder = ""
    var textFieldText = String()
    var clickArray = [Int]()
    var disposeBag = DisposeBag()
    typealias completion = (([Int], String) -> Void)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    convenience init(_ reviewAlert: Bool, _ title: String, _ content: String, _ placeholder: String, clickAction: @escaping completion) {
        self.init()
        
        self.placeholder = placeholder
        setConstraints()
        configure(title: title, content: content, placeholder: placeholder)
        buttonClick(action: clickAction)
        
        if reviewAlert {
            // 리뷰 이벤트 얼럿일 때
            alartReviewButton.isHidden = false
            alertSignButton.isHidden = true
            setAlertReviewButton()
            // 여기 부분 체크
            signTextview.snp.remakeConstraints { make in
                make.top.equalTo(alartReviewButton.snp.bottom).offset(24)
                make.leading.trailing.equalTo(alartReviewButton)
                make.height.equalTo(self.view.frame.height * 0.15)
            }
        } else {
            // 신고 이벤트 얼럿일 때
            alartReviewButton.isHidden = true
            alertSignButton.isHidden = false
            setSignAlertSignButton()
            
            signTextview.snp.remakeConstraints { make in
                make.top.equalTo(alertSignButton.snp.bottom).offset(24)
                make.leading.trailing.equalTo(alertSignButton)
                make.height.equalTo(self.view.frame.height * 0.15)
            }
        }

    }
    
    func setAlertReviewButton() {
        let first = alartReviewButton.firstLeftButton.rx.tap.scan(false) { state, value in !state }.startWith(false)
        let second = alartReviewButton.firstRightButton.rx.tap.scan(false) { state, value in !state }.startWith(false)
        let third = alartReviewButton.middleLeftButton.rx.tap.scan(false) { state, value in !state }.startWith(false)
        let fourth = alartReviewButton.middleRightButton.rx.tap.scan(false) { state, value in !state }.startWith(false)
        let fivth = alartReviewButton.lastLeftButton.rx.tap.scan(false) { state, value in !state }.startWith(false)
        let sixth = alartReviewButton.lastRightButton.rx.tap.scan(false) { state, value in !state }.startWith(false)
        
        Observable.combineLatest(first, second, third, fourth, fivth, sixth)
            .asDriver(onErrorJustReturn: (false, false, false, false, false, false))
            .drive(onNext: { [weak self] one, two, three, four, five, six in
                guard let self = self else {return}
                self.clickArray = []
                [one, two, three, four, five, six].forEach { state in
                    let number = state ? 1 : 0
                    self.clickArray.append(number)
                }
                for _ in 0...2 {
                    self.clickArray.append(0)
                }
                let status = self.clickArray.contains(1)
                if status {
                    self.submitButton.customLayout(.fill)
                    self.submitButton.isEnabled = true
                } else {
                    self.submitButton.customLayout(.disable)
                    self.submitButton.isEnabled = false
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func setSignAlertSignButton() {
        let first = alertSignButton.firstLeftButton.rx.tap.scan(false) { state, value in !state }.startWith(false)
        let second = alertSignButton.firstMiddelButton.rx.tap.scan(false) { state, value in !state }.startWith(false)
        let third = alertSignButton.firstRightButton.rx.tap.scan(false) { state, value in !state }.startWith(false)
        let fourth = alertSignButton.lastLeftButton.rx.tap.scan(false) { state, value in !state }.startWith(false)
        let fivth = alertSignButton.lastMiddleButton.rx.tap.scan(false) { state, value in !state }.startWith(false)
        let sixth = alertSignButton.lastRightButton.rx.tap.scan(false) { state, value in !state }.startWith(false)
        
        Observable.combineLatest(first, second, third, fourth, fivth, sixth)
            .asDriver(onErrorJustReturn: (false, false, false, false, false, false))
            .drive(onNext: { [weak self] one, two, three, four, five, six in
                guard let self = self else {return}
                self.clickArray = []
                [one, two, three, four, five, six].forEach { state in
                    let number = state ? 1 : 0
                    self.clickArray.append(number)
                }
                let status = self.clickArray.contains(1)
                if status {
                    self.submitButton.customLayout(.fill)
                    self.submitButton.isEnabled = true
                } else {
                    self.submitButton.customLayout(.disable)
                    self.submitButton.isEnabled = false
                }
                
            }).disposed(by: disposeBag)
    }
    
    // 음 그냥 Static으로 빼도 됐으려나 일단 사용해보면서 고민해보기
    func buttonClick(action: @escaping completion) {
        self.cancelButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        self.signTextview.rx.text.asDriver()
            .drive(onNext: { [weak self] text in
                guard let self = self else {return}
                guard let text = text else {return}
                self.textFieldText = text
            })
            .disposed(by: disposeBag)
        
        self.submitButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                action(self.clickArray, self.textFieldText)
            })
            .disposed(by: disposeBag)
    }
    
    func configure(title: String, content: String, placeholder: String) {
        view.backgroundColor = SacColor.color(.black).withAlphaComponent(0.5)
        alertTitle.text = title
        alertContent.text = content
        signTextview.delegate = self
        signTextview.text = placeholder
    }
    
    override func setConstraints() {
        view.addSubview(alertView)
        alertView.addSubview(alertTitle)
        alertView.addSubview(cancelButton)
        alertView.addSubview(alertContent)
        
        alertView.addSubview(alartReviewButton)
        alertView.addSubview(alertSignButton)
        
        alertView.addSubview(signTextview)
        
        alertView.addSubview(submitButton)
        
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        alertTitle.snp.makeConstraints { make in
            make.top.equalTo(alertView).inset(17)
            make.centerX.equalTo(alertView)
            make.leading.trailing.equalTo(alertView.safeAreaLayoutGuide).inset(16)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.trailing.top.equalTo(alertView).inset(16)
        }
        
        alertContent.snp.makeConstraints { make in
            make.centerX.equalTo(alertView)
            make.top.equalTo(alertTitle.snp.bottom).offset(16)
            make.leading.trailing.equalTo(alertView.safeAreaLayoutGuide).inset(16)
        }
        
        alertSignButton.snp.makeConstraints { make in
            make.top.equalTo(alertContent.snp.bottom).offset(24)
            make.leading.trailing.equalTo(alertContent)
        }
        
        alartReviewButton.snp.makeConstraints { make in
            make.top.equalTo(alertContent.snp.bottom).offset(24)
            make.leading.trailing.equalTo(alertContent)
        }
        
        signTextview.snp.makeConstraints { make in
            make.top.equalTo(alertSignButton.snp.bottom).offset(24)
            make.leading.trailing.equalTo(alertSignButton)
            make.height.equalTo(self.view.frame.height * 0.15)
        }
        
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(signTextview.snp.bottom).offset(24)
            make.leading.trailing.equalTo(alertSignButton)
            make.bottom.equalTo(alertView).inset(16)
        }
        
    }
    
}

extension SeSacTextViewAlert: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard let text = textView.text else {return}
        if text == self.placeholder {
            textView.text = ""
        }
        textView.textColor = SacColor.color(.black)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            textView.text = self.placeholder
            textView.textColor = SacColor.color(.gray7)
        } else {
            textView.textColor = SacColor.color(.black)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let text = textView.text ?? ""
        guard let range = Range(range, in: text)
        else {return false}
        
        let inputText = text.replacingCharacters(in: range, with: text)
        let limitCount = self.placeholder == "신고 사유를 적어주세요\n허위 신고 시 제재를 받을 수 있습니다" ? 300 : 500
        return inputText.count <= limitCount
    }
}

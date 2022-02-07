//
//  Custom+Alert.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/07.
//

import UIKit
import RxSwift

class SeSacAlert: BaseViewController {
    
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
    let alertContent = UILabel().then {
        let lineHeight = $0.setLineHeight(font: .title4_R)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.black)
        $0.textAlignment = .center
        $0.font = Font.title4_R14()
    }
    let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    let cancelButton = ButtonConfiguration(customType: .h48(type: .inactive, icon: false)).then {
        $0.setTitle("취소", for: .normal)
    }
    let okButton = ButtonConfiguration(customType: .h48(type: .fill, icon: false)).then {
        $0.setTitle("확인", for: .normal)
    }
    
    var disposeBag = DisposeBag()
    typealias completion = (() -> Void)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    convenience init(_ title: String, _ content: String, okAction: @escaping completion) {
        self.init()

        setConstraints()
        configure(title: title, content: content)
        buttonClick(action: okAction)
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
        
        self.okButton.rx.tap
            .asDriver()
            .drive(onNext: action)
            .disposed(by: disposeBag)
    }
    
    func configure(title: String, content: String) {
        view.backgroundColor = SacColor.color(.black).withAlphaComponent(0.5)
        alertTitle.text = title
        alertContent.text = content
    }
    
    override func setConstraints() {
        view.addSubview(alertView)
        alertView.addSubview(alertTitle)
        alertView.addSubview(alertContent)
        alertView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(okButton)
        
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        alertTitle.snp.makeConstraints { make in
            make.centerX.equalTo(alertView)
            make.leading.trailing.equalTo(alertView.safeAreaLayoutGuide).inset(16)
        }
        alertContent.snp.makeConstraints { make in
            make.centerX.equalTo(alertView)
            make.top.equalTo(alertTitle.snp.bottom).offset(10)
            make.leading.trailing.equalTo(alertView.safeAreaLayoutGuide).inset(16)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.centerX.equalTo(alertView)
            make.top.equalTo(alertContent.snp.bottom).offset(20)
            make.leading.trailing.equalTo(alertView.safeAreaLayoutGuide).inset(16)
        }
        // 추가 높이 작성
        alertView.snp.makeConstraints { make in
            make.top.equalTo(alertTitle).offset(-20)
            make.bottom.equalTo(buttonStackView).offset(20)
        }
    }
    
}

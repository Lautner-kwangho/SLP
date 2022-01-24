//
//  Custom+UIButton.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/18.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

enum inputTextCase {
    case inative
    case focus
    case active
    case disable
    case error
    case success
}

class InputText: UIView {

    let view = UIView().then {
        $0.backgroundColor = .clear
    }
    let textField = UITextField().then {
        $0.font = Font.title4_R14()
        $0.textColor = SacColor.color(.gray7)
        $0.backgroundColor = .clear
    }
    let lineView = UIView()
    let label = UILabel().then {
        $0.font = Font.body4_R12()
        $0.textColor = SacColor.color(.error)
    }
    
    var validText = BehaviorSubject<Bool>(value: false)
    var statusText = BehaviorSubject<inputTextCase>(value: .inative)
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(type: inputTextCase) {
        self.init()
        
        setConstraints()
        configure()
        
        statusText.onNext(type)
        textInputEditAction(type: type)
    }
    
    func textInputEditAction(type: inputTextCase) {
        
//        self.textField.rx.text.asDriver()
//            .distinctUntilChanged()
//            .map(textFieldValid)
//            .drive(onNext: { value in
//                print(value)
//                self.textFieldStatus(type)
//            })
//            .disposed(by: disposeBag)
        statusText
            .distinctUntilChanged()
            .map(textFieldStatus)
            .subscribe(onNext: { value in
                self.statusText.bind { value in
//                    print(value)
                }
            })
            .disposed(by: disposeBag)
    }

    func textFieldStatus(_ status: inputTextCase) {
        switch status {
        case .inative:
            viewStyle(viewColor: .white, lineColor: .gray3, fieldColor: .gray7, subLabel: nil, subHidden: true)
        case .focus:
            viewStyle(viewColor: .white, lineColor: .black, fieldColor: .black, subLabel: nil, subHidden: true)
        case .active:
            viewStyle(viewColor: .white, lineColor: .gray3, fieldColor: .black, subLabel: nil, subHidden: true)
        case .disable:
            viewStyle(viewColor: .gray3, lineColor: .white, fieldColor: .gray7, subLabel: nil, subHidden: true)
        case .error:
            viewStyle(viewColor: .white, lineColor: .error, fieldColor: .black, subLabel: "적합하지 않습니다! 다시 입력해주세요", subHidden: false)
            label.textColor = SacColor.color(.error)
        case .success:
            viewStyle(viewColor: .white, lineColor: .success, fieldColor: .black, subLabel: "정상진행 가능합니다", subHidden: false)
            label.textColor = SacColor.color(.success)
        }
    }
    
    func viewStyle(viewColor: SacColor, lineColor: SacColor, fieldColor: SacColor, subLabel: String?, subHidden: Bool) {
        view.backgroundColor = SacColor.color(viewColor)
        lineView.backgroundColor = SacColor.color(lineColor)
        textField.textColor = SacColor.color(fieldColor)
        label.text = subLabel
        label.isHidden = subHidden
    }
    
    func textFieldValid(_ text: String?) -> Bool {
        guard let count = text?.count else { return false }
        let value = count > 0 ? true : false
        return value
    }
    
    func configure() {
        backgroundColor = .white
        lineView.backgroundColor = .red
    }
    
    func setConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(68)
        }
        addSubview(view)
        view.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self)
            $0.height.equalTo(48)
        }
        view.addSubview(textField)
        textField.snp.makeConstraints {
            $0.centerY.equalTo(view)
            $0.leading.trailing.equalTo(view).inset(12)
        }
        
        addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom)
            $0.leading.trailing.equalTo(self)
            $0.height.equalTo(1)
        }
        
        addSubview(label)
        label.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(textField)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

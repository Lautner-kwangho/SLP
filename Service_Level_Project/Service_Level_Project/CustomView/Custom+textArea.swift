//
//  Custom+textArea.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/20.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

enum textAreaCase {
    case active
    case activeIcon
}

class TextArea: UIView {
    let view = UIView().then {
        $0.backgroundColor = SacColor.color(.gray1)
        $0.layer.cornerRadius = 8
    }
    let textField = UITextField().then {
        $0.font = Font.body3_R14()
        $0.placeholder = "메시지를 입력하세요"

        $0.textColor = SacColor.color(.black)
    }
    var imageButton = UIButton().then {
        $0.isHidden = true
    }
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(type: textAreaCase) {
        self.init()
        setConstraints()
        customAction(type: type)
    }
    
    func customAction(type: textAreaCase) {
        self.textField.rx.text.asDriver()
            .distinctUntilChanged()
            .map(textFieldValid)
            .drive(onNext: { value in
                if type == .activeIcon {
                    self.imageButton.isHidden = false
                    let imageName = value ? "arrow.sesac.fill" : "arrow.sesac"
                    self.imageButton.setImage(UIImage(named: imageName), for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func textFieldValid(_ text: String?) -> Bool {
        guard let count = text?.count else { return false }
        let value = count > 0 ? true : false
        return value
    }
    
    func setConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(52)
        }
        
        addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
        
        view.addSubview(textField)
        textField.snp.makeConstraints {
            $0.centerY.equalTo(view)
            $0.leading.trailing.equalTo(view).inset(12)
            $0.height.equalTo(24)
        }
        
        view.addSubview(imageButton)
        imageButton.snp.makeConstraints {
            $0.centerY.equalTo(view)
            $0.trailing.equalTo(view).inset(16)
            $0.width.height.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

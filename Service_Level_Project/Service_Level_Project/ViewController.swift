//
//  ViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/18.
//

import UIKit
import RxSwift

// test용임
class ViewController: BaseViewController {

    let label = UILabel()
    let inputText = InputText()
    var button2 = ButtonConfiguration(customType: .h40(type: .fill, icon: true))
    let textArea = TextArea(type: .active)
    let textArea2 = TextArea(type: .activeIcon)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        view.addSubview(label)
        // Do any additional setup after loading the view.
        label.frame =  CGRect(x: 100, y: 100, width: 100, height: 100)
        label.font = Font.display1_R20()
        label.text = "test"
        label.textColor = .black
        
        view.addSubview(inputText)
        inputText.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(50)
        }
        
        let testArray: [inputTextCase] = [.focus, .error, .active, .disable, .inative, .success]
        
        inputText.textField.rx.text
            .orEmpty.map(textFieldIsEmpty)
            .subscribe(onNext: { value in
                self.inputText.validText.onNext(value)
                self.inputText.statusText.onNext(testArray.randomElement()!)
            })
            .disposed(by: disposeBag)
        
        view.addSubview(button2)
        button2.snp.makeConstraints {
            $0.top.equalTo(inputText.snp.bottom).offset(20)
            $0.centerX.leading.trailing.equalTo(inputText)
        }
        button2.addTarget(self, action: #selector(clicked), for: .touchUpInside)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.label.font = Font.title1_M16()
            
        }
        view.addSubview(textArea)
        textArea.snp.makeConstraints {
            $0.top.equalTo(button2.snp.bottom).offset(20)
            $0.centerX.leading.trailing.equalTo(inputText)
        }
        
        let testAreaArray: [textAreaCase] = [.active, .activeIcon]
//        textArea.textField.rx.text
//            .orEmpty.map(textFieldIsEmpty)
//            .bind(onNext: { value in
//                self.textArea.validText.onNext(value)
//            })
//            .disposed(by: disposeBag)
        
        view.addSubview(textArea2)
        textArea2.snp.makeConstraints {
            $0.top.equalTo(textArea.snp.bottom).offset(20)
            $0.centerX.leading.trailing.equalTo(inputText)
        }
//        textArea2.textField.rx.text
//            .orEmpty.map(textFieldIsEmpty)
//            .bind(onNext: { value in
//                self.textArea.validText.onNext(value)
//            })
//            .disposed(by: disposeBag)
    }
    
    func textFieldIsEmpty(_ text: String) -> Bool {
        return text.count > 0 ? true : false
    }
    
    @objc func clicked() {
        // 후... 하루 다 썼네
        let random: [buttonCase] = [.outline, .cancel, .fill , .disable]
        buttonCase.customLayout(button2, random.randomElement()!)
        print("눌렀습니다")
    }


}


//
//  ViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/18.
//

import UIKit

class ViewController: UIViewController {

    let label = UILabel()
    let button = InputText()
    var button2 = ButtonConfiguration(customType: .h40(type: .fill, icon: true))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        view.addSubview(label)
        // Do any additional setup after loading the view.
        label.frame =  CGRect(x: 100, y: 100, width: 100, height: 100)
        label.font = Font.display1_R20()
        label.text = "test"
        label.textColor = .black
        
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(50)
        }
        
        view.addSubview(button2)
        button2.snp.makeConstraints {
            $0.top.equalTo(button.snp.bottom).offset(20)
            $0.centerX.leading.trailing.equalTo(button)
        }
        button2.addTarget(self, action: #selector(clicked), for: .touchUpInside)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.label.font = Font.title1_M16()
            
        }
    }
    
    @objc func clicked() {
        // 후... 하루 다 썼네
        let random: [buttonCase] = [.outline, .cancel, .fill , .disable]
        buttonCase.customLayout(button2, random.randomElement()!)
        print("눌렀습니다")
    }


}


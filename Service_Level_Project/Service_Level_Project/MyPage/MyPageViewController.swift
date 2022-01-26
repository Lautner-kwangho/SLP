//
//  MyPageViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/25.
//

import UIKit

class MyPageViewController: BaseViewController {
    let button = UIButton().then {
        $0.backgroundColor = .brown
        $0.setTitle("회원탈퇴", for: .normal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    @objc func buttonClicked() {
        print(1)
    }
    
    override func setConstraints() {
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }
    }
}

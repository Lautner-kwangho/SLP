//
//  ViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/18.
//

import UIKit

class ViewController: UIViewController {

    let label = UILabel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(label)
        // Do any additional setup after loading the view.
        label.frame =  CGRect(x: 100, y: 100, width: 100, height: 100)
        label.font = Font.display1_R20()
        label.text = "test"
        label.textColor = .black
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.label.font = Font.title1_M16()
        }
    }


}


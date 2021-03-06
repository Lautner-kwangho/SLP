//
//  BaseViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/18.
//

import UIKit
import Firebase
import RxCocoa
import RxSwift
import SnapKit
import Then
import Toast

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        setConstraints()
        configure()
    }
    
    func setConstraints() {
        
    }
    
    func configure() {
        
    }
    
}

extension BaseViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

//
//  UserImageBackgroundViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/15.
//

import UIKit
import RxSwift

class UserImageBackgroundViewController: BaseViewController {
    let userImageTableView = UITableView().then {
        $0.register(UserImageBackgroundCell.self, forCellReuseIdentifier: UserImageBackgroundCell.reuseIdentifier)
        $0.showsVerticalScrollIndicator = false
    }
    
    let viewModel = UserImageBackgroundViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        userImageTableView.delegate = self
        userImageTableView.dataSource = self
        userImageTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func setConstraints() {
        view.addSubview(userImageTableView)
        
        ShopViewController.sharedHeight
            .asDriver()
            .drive(onNext: { [weak self] height in
                guard let self = self else {return}
                self.userImageTableView.snp.makeConstraints {
                    $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(height)
                    $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
                }
            })
            .disposed(by: disposeBag)
        
    }
}


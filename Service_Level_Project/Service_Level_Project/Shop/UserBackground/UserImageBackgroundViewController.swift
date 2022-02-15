//
//  UserImageBackgroundViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/15.
//

import UIKit

class UserImageBackgroundViewController: BaseViewController {
    let userImageTableView = UITableView().then {
        $0.register(UserImageBackgroundCell.self, forCellReuseIdentifier: UserImageBackgroundCell.reuseIdentifier)
    }
    
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
        userImageTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}


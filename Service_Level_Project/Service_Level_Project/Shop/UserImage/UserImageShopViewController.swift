//
//  UserImageShopViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/15.
//

import UIKit

class UserImageShopViewController: BaseViewController {
    
    let userImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        let layer = UICollectionViewFlowLayout()
        layer.scrollDirection = .vertical
        $0.collectionViewLayout = layer
        $0.register(UserImageShopCell.self, forCellWithReuseIdentifier: UserImageShopCell.reuseIdentifier)
        $0.showsVerticalScrollIndicator = false
    }
    
    let viewModel = UserImageShopViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        userImageCollectionView.delegate = self
        userImageCollectionView.dataSource = self
    }
    
    override func setConstraints() {
        view.addSubview(userImageCollectionView)
        userImageCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(100)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
//            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

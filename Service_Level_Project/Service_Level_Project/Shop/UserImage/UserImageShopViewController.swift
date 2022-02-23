//
//  UserImageShopViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/15.
//

import UIKit
import RxSwift

class UserImageShopViewController: BaseViewController {
    
    let userImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        let layer = UICollectionViewFlowLayout()
        layer.scrollDirection = .vertical
        $0.collectionViewLayout = layer
        $0.register(UserImageShopCell.self, forCellWithReuseIdentifier: UserImageShopCell.reuseIdentifier)
        $0.showsVerticalScrollIndicator = false
    }
    
    let viewModel = UserImageShopViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        userImageCollectionView.delegate = self
        userImageCollectionView.dataSource = self
    }
    
    override func setConstraints() {
        view.addSubview(userImageCollectionView)
        
        ShopViewController.sharedHeight
            .asDriver()
            .drive(onNext: { [weak self] height in
                guard let self = self else {return}
                self.userImageCollectionView.snp.updateConstraints {
                    $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(height)
                    $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
                }
            })
            .disposed(by: disposeBag)
        
    }
}

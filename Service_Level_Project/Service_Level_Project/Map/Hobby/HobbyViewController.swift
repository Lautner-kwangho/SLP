//
//  HobbyViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/11.
//

import UIKit

final class HobbyViewController: BaseViewController {
    
    let letters = ["안녕","안녕하세요","안녕하세요 저는 포마입니다.","안녕하세요 만나서 정말 반갑습니다."]
    
    let searchBar = UISearchBar().then {
        $0.placeholder = "띄어쓰기로 복수 입력이 가능해요"
    }

    let hobbyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        let layer = UICollectionViewFlowLayout()
        layer.scrollDirection = .vertical
        $0.collectionViewLayout = layer
        $0.register(HobbyCollectionCell.self, forCellWithReuseIdentifier: HobbyCollectionCell.reuseIdentifier)
        $0.backgroundColor = .green
    }
    
    let sasecSearchButton = ButtonConfiguration(customType: .h48(type: .fill, icon: false)).then {
        $0.setTitle("새싹 찾기", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func configure() {
        view.backgroundColor = SacColor.color(.white)
        self.navigationController?.navigationBar.tintColor = SacColor.color(.black)
        
        
//        hobbyCollectionView.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
//        
//        if let flowLayout = hobbyCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        }
        self.hobbyCollectionView.delegate = self
        self.hobbyCollectionView.dataSource = self
    }
    
    override func setConstraints() {
        self.navigationItem.titleView = searchBar
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backPage))
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        view.addSubview(sasecSearchButton)
        view.addSubview(hobbyCollectionView)
        
        sasecSearchButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view).inset(50)
        }
        
        hobbyCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(sasecSearchButton.snp.top).inset(-16)
        }
        
        
        
    }
    
    @objc func backPage() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension HobbyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return letters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HobbyCollectionCell.reuseIdentifier, for: indexPath) as? HobbyCollectionCell else { return UICollectionViewCell() }
        let text = letters[indexPath.item]
        cell.hobbyButton.setTitle("\(text)", for: .normal)
        
        return cell
    }
    
}

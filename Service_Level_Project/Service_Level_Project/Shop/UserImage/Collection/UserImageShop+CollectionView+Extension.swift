//
//  UserImageShop+CollectionView+Extension.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/16.
//

import UIKit

extension UserImageShopViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.userTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserImageShopCell.reuseIdentifier, for: indexPath) as? UserImageShopCell else {return UICollectionViewCell()}
        
        let data = viewModel.userTitle[indexPath.item]
        cell.userImage.image = SeSacUserImageManager.image(indexPath.item)
        cell.userImageTitle.text = data.title
        cell.userImageContent.text = data.content
        cell.userImagePrice.text = data.price
        
        if cell.userImagePrice.text == "보유" {
            cell.userImagePrice.textColor = SacColor.color(.gray7)
            cell.userImagePrice.backgroundColor = SacColor.color(.gray2)
        }
        
        return cell
    }
}

extension UserImageShopViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserImageShopCell.reuseIdentifier, for: indexPath) as? UserImageShopCell else {return .zero}
        
        let width = collectionView.frame.width / 2 - 4
        // 나중에 해보는 걸로
//        let height = cell.systemLayoutSizeFitting(CGSize(width: cell.frame.width, height: cell.frame.height), withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required).height
        
        let size = CGSize(width: width, height: width * 1.5)
        return size
    }
}

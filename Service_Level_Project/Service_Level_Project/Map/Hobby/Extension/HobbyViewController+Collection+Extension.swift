//
//  HobbyViewController+Collection+Extension.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/11.
//

import UIKit

extension HobbyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HobbyCollectionViewHeader.reuseIdentifier, for: indexPath) as? HobbyCollectionViewHeader else { return UICollectionReusableView()}
            if indexPath.section == 0 {
                header.title.text = "지금 주변에는"
            } else {
                header.title.text = "내가 하고 싶은"
            }
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            let number = self.recommendHobby.count + self.aroundHobby.count
            return number
        } else {
            var number = 0
            output.myHobbyList.asDriver()
                .drive(onNext: { text in
                    number = text.count
                })
                .disposed(by: disposeBag)
            return number
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HobbyCollectionCell.reuseIdentifier, for: indexPath) as? HobbyCollectionCell else { return UICollectionViewCell() }
        
        if indexPath.section == 0 {
            let data = self.recommendHobby + self.aroundHobby
            let text = data[indexPath.item]
            
            cell.hobbyButton.setTitle("\(text)", for: .normal)
            cell.myhobbyButton.isHidden = true
            if indexPath.item < self.recommendHobby.count {
                cell.aroundLayoutConfigure(indexPath)
            }
        } else {
            var data = [String]()
            output.myHobbyList.asDriver()
                .drive(onNext: { text in
                    data = []
                    text.forEach {
                        data.append($0)
                    }
                })
                .disposed(by: disposeBag)
            
            cell.myhobbyButton.setTitle("\(data[indexPath.item])", for: .normal)

            
            cell.myhobbyButton.rx.tap
                .asDriver().drive(onNext: { [weak self] _ in
                    guard let self = self else {return}
                    let title = data[indexPath.item]
                    self.removeNumber.accept(title)
                })
                .disposed(by: disposeBag)
            
            cell.hobbyButton.isHidden = true
            
            cell.myselfLayoutConfigure(indexPath)
        }
        
        return cell
    }
}



extension HobbyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HobbyCollectionCell.reuseIdentifier, for: indexPath) as? HobbyCollectionCell else { return .zero }
        
        if indexPath.section == 0 {
            let data = self.recommendHobby + self.aroundHobby
            let text = data[indexPath.item]
            
            cell.hobbyButton.setTitle("\(text)", for: .normal)
            cell.myhobbyButton.isHidden = true
            
            cell.hobbyButton.sizeToFit()
            let cellWidth = cell.hobbyButton.frame.width + 30
            return CGSize(width: cellWidth, height: 35)
        } else {
            var data = [String]()
            output.myHobbyList.asDriver()
                .drive(onNext: { text in
                    data = []
                    text.forEach {
                        data.append($0)
                    }
                })
                .disposed(by: disposeBag)
            
            cell.myhobbyButton.setTitle("\(data[indexPath.item])", for: .normal)
            
            cell.hobbyButton.isHidden = true
            
            cell.myhobbyButton.sizeToFit()
            let cellWidth = cell.myhobbyButton.frame.width + 30
            return CGSize(width: cellWidth, height: 35)
        }
        
    }
}

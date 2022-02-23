//
//  UserImageBackground+TableView+Extension.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/15.
//

import UIKit

extension UserImageBackgroundViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.backgroundTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserImageBackgroundCell.reuseIdentifier, for: indexPath) as? UserImageBackgroundCell else {return UITableViewCell()}
        cell.selectionStyle = .none
        
        let data = viewModel.backgroundTitle[indexPath.row]
        cell.backgroundImage.image = SeSacUserBackgroundImageManager.image(indexPath.row)
        cell.backgroundTitle.text = data.title
        cell.backgroundContent.text = data.content
        cell.backgroundPrice.text = data.price
        
        if cell.backgroundPrice.text == "보유" {
            cell.backgroundPrice.textColor = SacColor.color(.gray7)
            cell.backgroundPrice.backgroundColor = SacColor.color(.gray2)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ShopViewController.userBackgroundImageNumber.accept(indexPath.item)
    }
    
}

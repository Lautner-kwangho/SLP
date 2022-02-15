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
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserImageBackgroundCell.reuseIdentifier, for: indexPath) as? UserImageBackgroundCell else {return UITableViewCell()}
        
        return cell
    }
    
    
}

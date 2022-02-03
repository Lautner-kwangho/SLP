//
//  ReusableName+Ptotocol.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/02.
//

import UIKit

protocol ReusableName {
    static var reuseIdentifier: String { get }
}

extension UITableViewCell: ReusableName {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}

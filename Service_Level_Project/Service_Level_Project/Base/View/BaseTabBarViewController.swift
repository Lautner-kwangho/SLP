//
//  BaseTabBarViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/08.
//

import UIKit

final class BaseTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let first = UINavigationController(rootViewController: MapViewController())
        let second = UINavigationController(rootViewController: ShopViewController())
        let third = UINavigationController(rootViewController: MyInfoViewController())
        
        first.title = "홈"
        
        second.title = "새싹샵"
        second.navigationBar.backgroundColor = SacColor.color(.white)
        second.navigationBar.topItem?.title = "새싹샵"
        
        third.title = "내정보"
        third.navigationBar.topItem?.title = "내정보"
        
        setViewControllers([first, second, third], animated: true)
        
        selectedIndex = 2 // 2로 바꿔주기
        
        tabBar.barTintColor = SacColor.color(.white)
        tabBar.backgroundColor = SacColor.color(.white)
        tabBar.tintColor = SacColor.color(.green)
        
        guard let items = tabBar.items else { return }
        
        items[0].image = UIImage(named: "home")
        items[1].image = UIImage(named: "shop")
        items[2].image = UIImage(named: "my.Property")
    }
}

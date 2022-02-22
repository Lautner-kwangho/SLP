//
//  ShopViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/08.
//

import UIKit
import Tabman
import Pageboy

class ShopViewController: TabmanViewController {
    // Fimga에 있는 거 처럼 하려면 이걸 또 상속 받아서 하면 편할 듯
    private var viewController = [UserImageShopViewController(), UserImageBackgroundViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        tabmanSetting()
    }
    
    private func setNavigation() {
        self.view.backgroundColor = SacColor.color(.white)
        self.title = "새싹샵"
    }
    
    private func tabmanSetting() {
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        
        bar.layout.transitionStyle = .snap
        bar.layout.contentMode = .fit
        bar.backgroundView.style = .blur(style: .light)
        bar.indicator.tintColor = SacColor.color(.green)
        
        bar.buttons.customize { button in
            button.tintColor = SacColor.color(.gray6)
            button.font = Font.title6_R12()
            
            button.selectedTintColor = SacColor.color(.green)
            button.selectedFont = Font.title6_R12()
        }
        let vieww = UIView().then {
            $0.backgroundColor = .blue
        }
        
//        self.view.addSubview(vieww)
//        vieww.snp.makeConstraints { make in
//            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
//            make.height.equalTo(100)
//        }
        addBar(bar, dataSource: self, at: .top)
    }
    
}

extension ShopViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewController.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewController[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title = index == 0 ? "새싹" : "배경"
        return TMBarItem(title: title)
    }
}

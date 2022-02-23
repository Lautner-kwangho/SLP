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
    static let shared = ShopViewController()
    private var viewController = [UserImageShopViewController(), UserImageBackgroundViewController()]
    
    let bar = TMBar.ButtonBar()
    
    let headerView = UIView().then {
        $0.backgroundColor = .blue
    }
    let backgroundImage = UIImageView()
    let userImage = UIImageView()
    
    let testTabView = UIView()
    
    
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
        
        self.view.addSubview(headerView)
        headerView.addSubview(backgroundImage)
        headerView.addSubview(userImage)
        
        self.view.addSubview(testTabView)

        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(self.view.frame.size.width / 2)
            $0.bottom.equalTo(backgroundImage)
        }
        
        backgroundImage.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(headerView)
            $0.height.equalTo(self.view.frame.size.width / 2)
        }
        
        userImage.snp.makeConstraints {
            $0.bottom.leading.trailing.equalTo(backgroundImage)
            $0.centerX.equalTo(backgroundImage)
        }
        
        addBar(bar, dataSource: self, at: .custom(view: testTabView, layout: { view in
            view.snp.makeConstraints { make in
                make.top.equalTo(self.headerView.snp.bottom)
                make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
                make.height.equalTo(50)
            }
        }))
        
        
        print("테이블 높이 구하기", headerView.frame.size.height + CGFloat(50.0))
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

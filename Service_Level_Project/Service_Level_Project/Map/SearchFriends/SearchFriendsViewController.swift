//
//  SearchFriendsViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/12.
//

import UIKit
import Tabman
import Pageboy

class SearchFriendsViewController: TabmanViewController {
    
    private var viewController = [AroundSeSacViewController(), RequestSeSacViewController()]
    
    lazy var backButton = UIBarButtonItem(image: UIImage(systemName: "arrow"), style: .plain, target: self, action: #selector(backButtonClicked))
    
    lazy var stopButton = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(stopButtonClicked))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationSetting()
        tabmanSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func navigationSetting() {
        self.navigationController?.navigationBar.backgroundColor = SacColor.color(.white)
        self.navigationController?.navigationBar.tintColor = SacColor.color(.black)
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = stopButton
        self.title = "새싹 찾기"
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
        
        addBar(bar, dataSource: self, at: .top)
    }
    
    @objc private func backButtonClicked(_ sender: Any) {
        print("중단 안하고 맵으로 돌아와서 ")
    }
    
    @objc private func stopButtonClicked(_ sender: Any) {
        print("중단 큐 주고 난 뒤에 맵으로 돌아가야함")
    }
}

extension SearchFriendsViewController: PageboyViewControllerDataSource, TMBarDataSource {
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
        let title = index == 0 ? "주변 새싹" : "받은 요청"
        return TMBarItem(title: title)
    }
    
    
}

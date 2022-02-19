//
//  SearchFriendsViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/12.
//

import UIKit
import Tabman
import Pageboy

final class SearchFriendsViewController: TabmanViewController {
    
    private var viewController = [AroundSeSacViewController(), RequestSeSacViewController()]
    
    lazy var backButton = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: #selector(backButtonClicked))
    
    lazy var stopButton = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(stopButtonClicked))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationSetting()
        tabmanSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
        UserDefaults.standard.set(SeSacMapButtonImageManager.imageName(1), forKey: UserDefaultsManager.mapButton)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func stopButtonClicked(_ sender: Any) {
        SeSacURLNetwork.shared.friendsRequestStop {
                    UserDefaults.standard.set(SeSacMapButtonImageManager.imageName(0), forKey: UserDefaultsManager.mapButton)
            self.navigationController?.popToRootViewController(animated: true)
        } failErrror: { errorCode in
            guard let code = errorCode else {return}
            switch code {
            case "201":
                let alertPage = SeSacAlert("나갈거에요?", "엇..이미 매칭되어 있는 상태입니다") {
                    self.dismiss(animated: true)
                    self.navigationController?.pushViewController(ChattingViewController(), animated: true)
                }
                alertPage.cancelButton.isHidden = true
                alertPage.modalPresentationStyle = .overFullScreen
                self.present(alertPage, animated: true, completion: nil)
            default:
                break
            }
        }
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

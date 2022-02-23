//
//  ShopViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/08.
//

import UIKit
import Tabman
import Pageboy
import RxSwift
import RxRelay

class ShopViewController: TabmanViewController {
    static var sharedHeight = BehaviorRelay<CGFloat>(value: 200)
    
    static var userBackgroundImageNumber = BehaviorRelay<Int>(value: 0)
    static var userImageNumber =  BehaviorRelay<Int>(value: 0)
    
    let imageWeight: CGFloat = 348
    let imageHeight: CGFloat = 174
    
    private var viewController = [UserImageShopViewController(), UserImageBackgroundViewController()]
    
    let bar = TMBar.ButtonBar()
    
    let headerView = UIView().then {
        $0.layer.masksToBounds = true
    }
    let backgroundImage = UIImageView().then {
        $0.image = SeSacUserBackgroundImageManager.image(0)
        $0.contentMode = .scaleAspectFit
        
    }
    let userImage = UIImageView().then {
        $0.image = SeSacUserImageManager.image(0)
    }
    let saveButton = ButtonConfiguration(customType: .h40(type: .fill, icon: false)).then {
        $0.setTitle("저장하기", for: .normal)
        $0.sizeToFit()
    }
    
    let TempTabView = UIView()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        tabmanSetting()
        bind()
    }
    
    private func bind() {
        ShopViewController.userBackgroundImageNumber.asDriver()
            .drive(onNext: { [weak self] value in
                guard let self = self else {return}
                self.backgroundImage.image = SeSacUserBackgroundImageManager.image(value)
            })
            .disposed(by: disposeBag)
        
        ShopViewController.userImageNumber.asDriver()
            .drive(onNext: { [weak self] value in
                guard let self = self else {return}
                self.userImage.image = SeSacUserImageManager.image(value)
            })
            .disposed(by: disposeBag)
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
        headerView.addSubview(saveButton)
        
        self.view.addSubview(TempTabView)
        
        let imageviewHeight: CGFloat = ( imageHeight * view.frame.size.width ) / imageWeight
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(14)
            $0.height.equalTo(imageviewHeight)
            $0.bottom.equalTo(backgroundImage)
        }
        
        backgroundImage.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(headerView)
            $0.height.equalTo(imageviewHeight)
        }
        
        userImage.snp.makeConstraints {
            $0.bottom.equalTo(backgroundImage.snp.bottom)
            $0.centerX.equalTo(backgroundImage)
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(backgroundImage).inset(20)
            $0.trailing.equalTo(backgroundImage).inset(20)
        }
        
        addBar(bar, dataSource: self, at: .custom(view: TempTabView, layout: { view in
            view.snp.makeConstraints { make in
                make.top.equalTo(self.headerView.snp.bottom)
                make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
                make.height.equalTo(50)
            }
        }))
        
        ShopViewController.sharedHeight.accept(imageviewHeight + CGFloat(50.0))
        
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

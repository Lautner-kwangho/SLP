//
//  SelectGenderViewModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/25.
//

import UIKit
import RxSwift
import Toast

class SelectGenderViewModel {
    let Title = "성별을 선택해주세요"
    let subTItle = "새싹 찾기 기능을 이용하기 위해서 필요해요!"
    let customButtonTitle = "다음"
    
    var maleClicked = false
    var femaleClicked = false
    var chooseGender = 0
    
    let disposeBag = DisposeBag()
    let toastStyle = ToastStyle()
    
    func clickedGenderButton(_ vc: UIViewController, _ button: UIButton) {
        button.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                
                if self.maleClicked, self.femaleClicked {
                    self.chooseGender = 2
                    vc.view.makeToast("두가지 성별을 동시에 선택할 수 없습니다", duration: 1, position: .center, title: "", style: self.toastStyle, completion: nil)
                } else if self.maleClicked {
                    self.chooseGender = 0
                } else if self.femaleClicked {
                    self.chooseGender = 1
                } else {
                    self.chooseGender = -1
                }
                UserDefaults.standard.set(self.chooseGender, forKey: UserDefaultsManager.gender)
                self.authRegisterLogic()
            })
            .disposed(by: disposeBag)
    }
    
    func authRegisterLogic() {
        if chooseGender == 2 {
            // 성별 부적합
        } else {
            // 다음 단계 진행
            SeSacURLNetwork.shared.registMember { data in
                SeSacURLNetwork.shared.loginMember { data in
                    print(data)
                    
                    DispatchQueue.main.async {
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: MyInfoViewController())
                        windowScene.windows.first?.makeKeyAndVisible()
                    }
                } failErrror: { error in
                    print(error)
                }
            } failErrror: { error in
                guard let error = error else { return }
                DispatchQueue.main.async {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: CreateNicknameViewController())
                    if error == "201" {
                        windowScene.windows.first?.rootViewController!.view.makeToast("닉네임을 다시 입력해주세요", position: .center)
                    } else if error == "202" {
                        windowScene.windows.first?.rootViewController!.view.makeToast("이미 가입한 유저입니다", position: .center)
                    } else if error == "401"{
                        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: SelectGenderViewController())
                    } else {
                        windowScene.windows.first?.rootViewController?.view.makeToast(error)
                    }
                    windowScene.windows.first?.makeKeyAndVisible()
                }
                
            }
        }
    }
}

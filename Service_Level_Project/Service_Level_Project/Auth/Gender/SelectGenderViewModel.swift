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
    var chooseGender = BehaviorSubject<Int>(value: 0)
    
    let disposeBag = DisposeBag()
    let toastStyle = ToastStyle()
    
    func clickedGenderButton(_ vc: UIViewController, _ button: UIButton) {
        button.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                if self.maleClicked, self.femaleClicked {
                    self.chooseGender.onNext(2)
                    vc.view.makeToast("두가지 성별을 동시에 선택할 수 없습니다", duration: 1, position: .center, title: "", style: self.toastStyle, completion: nil)
                } else if self.maleClicked {
                    self.chooseGender.onNext(0)
                } else if self.femaleClicked {
                    self.chooseGender.onNext(1)
                } else {
                    self.chooseGender.onNext(-1)
                }
                self.authRegisterLogic()
            })
            .disposed(by: disposeBag)
    }
    
    func authRegisterLogic() {
        var genderCode = 2
        chooseGender
            .distinctUntilChanged()
            .bind { code in
                genderCode = code
            }.disposed(by: disposeBag)
        if genderCode == 2 {
            print("성별 부적합")
        } else {
            print("다음 단계 진행")
        }
    }
}

//
//  BirthdayViewModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/25.
//

import UIKit
import RxSwift

class BirthdayViewModel {
    
    let Title = "생년월일을 알려주세요"
    let customButtonTitle = "다음"
    var birthday = ""
    
    let selectDate = BehaviorSubject<Date>(value: Date())
    let disposeBag = DisposeBag()
    
    func savedBirthday(_ picker : UIDatePicker, _ year: InputText, _ month: InputText, _ day: InputText) {
        let birthday = UserDefaults.standard.string(forKey: "birthday")
        guard let birthday = birthday else { return }

        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ko-KR")
        formatter.timeZone = .autoupdatingCurrent
        let userBirthday = formatter.date(from: birthday)
        
        guard let userBirthday = userBirthday else { return }
        let addHourDate = Calendar.current.date(byAdding: .hour, value: 21, to: userBirthday)
        
        guard let addHourDate = addHourDate else { return }
        let date = Calendar.current.dateComponents([.year, .month, .day], from: addHourDate)
        year.textField.text = "\(date.year!)"
        month.textField.text = "\(date.month!)"
        day.textField.text = "\(date.day!)"
        picker.date = addHourDate
    }
    
    func selectedDatePicker(_ picker: UIDatePicker, _ year: InputText, _ month: InputText, _ day: InputText) {
        picker.rx.date.asDriver()
            .drive(onNext: { date in
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .short
                formatter.locale = Locale(identifier: "ko-KR")
                formatter.timeZone = .autoupdatingCurrent
//                formatter.locale = Locale(identifier: Locale.current.identifier)
//                formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
                let birthday = formatter.string(from: date)
                self.birthday = birthday
                
                self.selectDate.onNext(date)
                let date = Calendar.current.dateComponents([.year, .month, .day], from: date)
                year.textField.text = "\(date.year!)"
                month.textField.text = "\(date.month!)"
                day.textField.text = "\(date.day!)"
            })
            .disposed(by: disposeBag)
    }
    
    func setButtonUI(_ button: UIButton) {
        self.selectDate
            .bind { date in
                button.isEnabled = true
                buttonCase.customLayout(button, .fill)
            }
            .disposed(by: disposeBag)
    }
    
    func clickedButton(_ vc: UIViewController, _ button: UIButton) {
        button.rx.tap
            .bind(onNext: { _ in
                let birthday = UserDefaults.standard.string(forKey: "birthday")
                if birthday == nil {
                    UserDefaults.standard.set(self.birthday, forKey: "birthday")
                }
                vc.navigationController?.pushViewController(EmailViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
}

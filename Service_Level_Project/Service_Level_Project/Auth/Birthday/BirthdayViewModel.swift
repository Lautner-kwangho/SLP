//
//  BirthdayViewModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/25.
//
import UIKit
// 여기한번 정리하기
import Foundation

import RxSwift
import RxCocoa
import RxRelay

final class BirthdayViewModel: BaseViewModel {
    
    //MARK: Input, Output
    struct Input {
        let pickviewDate: ControlProperty<Date>
//        let inputNickname: Driver<String>
    }
    
    struct Output {
//        let outputNickname: Driver<String>
//        let nicknameUIStatus: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    //MARK: Transform(input:)
    func transform(input: Input) -> Output {
         
        return Output()
    }
    
    //MARK: 기본 텍스트 입력
    let Title = "생년월일을 알려주세요"
    let customButtonTitle = "다음"
    var birthday = ""
    
    
    // 밑에 레거시 코드
    let selectDate = BehaviorSubject<Date>(value: Date())
    
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
        let addHourDate = Calendar.current.date(byAdding: .hour, value: 9, to: userBirthday)
        
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
    
    func setButtonUI(_ button: ButtonConfiguration) {
        self.selectDate
            .bind { date in
                button.isEnabled = true
                button.customLayout(.fill)
            }
            .disposed(by: disposeBag)
    }
    
    func clickedButton(_ vc: UIViewController, _ button: UIButton) {
        button.rx.tap
            .bind(onNext: { _ in
                let limitDate = Calendar.current.date(byAdding: .year, value: -17, to: Date().addingTimeInterval(32400))!
                let limitcompare = Calendar.current.dateComponents([.year, .month, .day], from: limitDate)

                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .short
                formatter.locale = Locale(identifier: "ko-KR")
                formatter.timeZone = .autoupdatingCurrent
                let selfDate = formatter.date(from: self.birthday)!
                let selfDateCompare = Calendar.current.dateComponents([.year, .month, .day], from: selfDate)

                if limitcompare == selfDateCompare {
                    vc.navigationController?.pushViewController(EmailViewController(), animated: true)
                } else {
                    DispatchQueue.global().async {
                        UserDefaults.standard.set(self.birthday, forKey: "birthday")
                        DispatchQueue.main.async {
                            vc.navigationController?.pushViewController(EmailViewController(), animated: true)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
}

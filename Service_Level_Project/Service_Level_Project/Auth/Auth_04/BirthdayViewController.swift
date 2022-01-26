//
//  BirthdayViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/25.
//

import UIKit

class BirthdayViewController: AuthBaseViewController {
    
    let calendarStatckView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    
    let yearView = UIView()
    let monthView = UIView()
    let dayView = UIView()
    
    let yearTextField = InputText(type: .active).then {
        $0.textField.placeholder = "1990"
        $0.textField.textAlignment = .center
        $0.textField.isEnabled = false
    }
    let monthTextField = InputText(type: .active).then {
        $0.textField.placeholder = "1"
        $0.textField.textAlignment = .center
        $0.textField.isEnabled = false
    }
    let dayTextField = InputText(type: .active).then {
        $0.textField.placeholder = "1"
        $0.textField.textAlignment = .center
        $0.textField.isEnabled = false
    }
    let selectDate = UIDatePicker().then {
        $0.preferredDatePickerStyle = .wheels
        $0.backgroundColor = SacColor.color(.gray3)
        $0.datePickerMode = .date
        $0.locale = Locale(identifier: "ko-KR")
        $0.timeZone = .autoupdatingCurrent
    
        let limitDate = Calendar.current.date(byAdding: .year, value: -17, to: Date().addingTimeInterval(32400))
        $0.maximumDate = limitDate
    }
    let yearLabel = UILabel().then {
        $0.text = "년"
        let lineHeight = $0.setLineHeight(font: .title2_R)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.black)
        $0.textAlignment = .center
        $0.font = Font.title2_R16()
    }
    let monthLabel = UILabel().then {
        $0.text = "월"
        let lineHeight = $0.setLineHeight(font: .title2_R)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.black)
        $0.textAlignment = .center
        $0.font = Font.title2_R16()
    }
    let dayLabel = UILabel().then {
        $0.text = "일"
        let lineHeight = $0.setLineHeight(font: .title2_R)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.black)
        $0.textAlignment = .center
        $0.font = Font.title2_R16()
    }
    
    let viewModel = BirthdayViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.savedBirthday(selectDate ,yearTextField, monthTextField, dayTextField)
    }
    
    override func configure() {
        firstLabel.text = viewModel.Title
        customButton.setTitle(viewModel.customButtonTitle, for: .normal)
        
        [yearTextField, monthTextField, dayTextField].forEach { view in
            view.textField.inputView = selectDate
        }
        viewModel.selectedDatePicker(selectDate, yearTextField, monthTextField, dayTextField)
        viewModel.setButtonUI(customButton)
        viewModel.clickedButton(self, customButton)
    }
    
    override func setConstraints() {
        
        let topInset = deviceHeight * 0.2
        let bottomInset = deviceHeight * 0.42
        
        view.addSubview(firstLabel)
        firstLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(topInset)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        view.addSubview(secondLabel)
        secondLabel.snp.makeConstraints {
            $0.top.equalTo(firstLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(firstLabel)
        }
        
        view.addSubview(customButton)
        customButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(bottomInset)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        view.addSubview(middleView)
        middleView.snp.makeConstraints {
            $0.top.equalTo(secondLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customButton.snp.top)
        }
        
        view.addSubview(selectDate)
        selectDate.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(view.frame.height * 0.3)
        }
        
        // 아 그냥 스텍 뷰로 해줬어야 했나; 그냥 다시 깔끔하게 스텍뷰로 하자
        middleView.addSubview(calendarStatckView)
        [yearView, monthView, dayView].forEach {
            calendarStatckView.addArrangedSubview($0)
        }
        
        calendarStatckView.snp.makeConstraints {
            $0.centerY.equalTo(middleView)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(middleView)
        }
        
        yearView.addSubview(yearTextField)
        yearView.addSubview(yearLabel)
        yearTextField.snp.makeConstraints {
            $0.width.equalTo(view.frame.width * 0.21)
            $0.leading.centerY.equalTo(yearView)
        }
        yearLabel.snp.makeConstraints {
            $0.centerY.equalTo(yearTextField.textField)
            $0.leading.equalTo(yearTextField.snp.trailing).offset(4)
        }

        monthView.addSubview(monthTextField)
        monthView.addSubview(monthLabel)
        monthTextField.snp.makeConstraints {
            $0.width.equalTo(view.frame.width * 0.21)
            $0.leading.centerY.equalTo(monthView)
        }
        monthLabel.snp.makeConstraints {
            $0.centerY.equalTo(monthTextField.textField)
            $0.leading.equalTo(monthTextField.snp.trailing).offset(4)
        }

        dayView.addSubview(dayTextField)
        dayView.addSubview(dayLabel)
        dayTextField.snp.makeConstraints {
            $0.width.equalTo(view.frame.width * 0.21)
            $0.leading.centerY.equalTo(dayView)
        }
        dayLabel.snp.makeConstraints {
            $0.centerY.equalTo(dayTextField.textField)
            $0.leading.equalTo(dayTextField.snp.trailing).offset(4)
        }

    }
}

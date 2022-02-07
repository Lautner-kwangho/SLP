//
//  MyPageTableViewCell.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/06.
//

import UIKit
import RxSwift
import RxRelay
import MultiSlider

class MyPageTableViewCell: UITableViewCell {
    var startAge = BehaviorRelay(value: 18)
    var lastAge = BehaviorRelay(value: 65)
    var disposeBag = DisposeBag()
    
    let maleButton = ButtonConfiguration(customType: .h48(type: .inactive, icon: false)).then {
        $0.setTitle("남자", for: .normal)
    }
    let femaleButton = ButtonConfiguration(customType: .h48(type: .inactive, icon: false)).then {
        $0.setTitle("여자", for: .normal)
    }
    
    let hobbyTextField = InputText(type: .inactive).then {
        $0.textField.placeholder = "취미를 입력해주세요"
    }
    
    let searchSwitch = UISwitch()
    
    let ageLevel = UILabel().then {
        let lineHeight = $0.setLineHeight(font: .title3_M)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.green)
        $0.textAlignment = .left
        $0.font = Font.title3_M14()
    }
    
    let slider = MultiSlider().then {
        $0.minimumValue = 18
        $0.maximumValue = 65
        $0.orientation = .horizontal
        $0.outerTrackColor = SacColor.color(.gray2)
        $0.tintColor = SacColor.color(.green)
        $0.trackWidth = 4
        $0.hasRoundTrackEnds = true
        $0.showsThumbImageShadow = false
        $0.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
    }
    
    let title = UILabel().then {
        let lineHeight = $0.setLineHeight(font: .title4_R)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.black)
        $0.textAlignment = .left
        $0.font = Font.title4_R14()
    }
    
    func cellConfigure(_ indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            self.contentView.addSubview(self.maleButton)
            self.contentView.addSubview(self.femaleButton)
            
            self.maleButton.rx.tap
                .asDriver()
                .drive(onNext: { status in
                    MyPageViewModel.maleSwitch = !MyPageViewModel.maleSwitch
                    if MyPageViewModel.maleSwitch {
                        self.maleButton.customLayout(.fill)
                    } else {
                        self.maleButton.customLayout(.inactive)
                    }
                })
                .disposed(by: disposeBag)
            
            self.femaleButton.rx.tap
                .asDriver()
                .drive(onNext: { status in
                    MyPageViewModel.femaleSwitch = !MyPageViewModel.femaleSwitch
                    if MyPageViewModel.femaleSwitch {
                        self.femaleButton.customLayout(.fill)
                    } else {
                        self.femaleButton.customLayout(.inactive)
                    }
                })
                .disposed(by: disposeBag)
            
            self.femaleButton.snp.makeConstraints { make in
                make.top.equalTo(self.contentView)
                make.bottom.equalTo(self.contentView)
                make.trailing.equalTo(self.contentView).inset(16)
                make.width.equalTo(56)
            }
            self.maleButton.snp.makeConstraints { make in
                make.trailing.equalTo(femaleButton.snp.leading).offset(-8)
                make.centerY.equalTo(femaleButton)
                make.width.equalTo(femaleButton)
            }
        } else if indexPath.row == 1 {
            self.contentView.addSubview(self.hobbyTextField)
            self.hobbyTextField.snp.makeConstraints { make in
                make.top.bottom.equalTo(self.contentView).inset(13)
                make.width.equalTo(self.frame.size.width / 2)
                make.trailing.equalTo(self.contentView).inset(16)
                make.centerY.equalTo(self.contentView).offset(10)
            }
            
        } else if indexPath.row == 2 {
            self.contentView.addSubview(self.searchSwitch)
            
            self.searchSwitch.rx.controlEvent(.valueChanged)
                .asDriver()
                .drive(onNext: { _ in
                    MyPageViewModel.searchSwitch = !MyPageViewModel.searchSwitch
                    self.searchSwitch.isOn = MyPageViewModel.searchSwitch
                })
                .disposed(by: disposeBag)
            
            self.searchSwitch.snp.makeConstraints { make in
                make.top.equalTo(self.contentView).inset(10)
                make.bottom.equalTo(self.contentView).inset(10)
                make.trailing.equalTo(self.contentView).inset(16)
                make.centerY.equalTo(self.contentView)
            }
            
        } else if indexPath.row == 3 {
            self.contentView.addSubview(ageLevel)
            ageLevel.snp.makeConstraints { make in
                make.top.equalTo(self.contentView).inset(16)
                make.trailing.equalTo(self.contentView).inset(16)
            }
            
            self.title.snp.remakeConstraints {
                $0.leading.equalTo(self).inset(16)
                $0.top.equalTo(self).inset(13)
            }

            let testView = UIView().then {
                $0.backgroundColor = .clear
                $0.layer.masksToBounds = true
            }
            self.contentView.addSubview(testView)
            testView.snp.makeConstraints { make in
                make.top.equalTo(ageLevel.snp.bottom)
                make.trailing.equalTo(self.contentView)
                make.height.equalTo(60)
                make.leading.trailing.equalTo(self.contentView)
                make.bottom.equalTo(self.contentView.snp.bottom)
            }
            testView.addSubview(slider)
            slider.snp.makeConstraints { make in
                make.center.equalTo(testView)
                make.leading.trailing.equalTo(testView).inset(16)
            }
            
            Observable.combineLatest(self.startAge, self.lastAge)
                .asDriver(onErrorJustReturn: (0, 60))
                .drive(onNext: { start, last in
                    self.ageLevel.text = "\(start) - \(last)"
                })
                .disposed(by: disposeBag)
        }
    }
    
    @objc func sliderChanged(slider: MultiSlider) {
        self.startAge.accept(Int(floor(slider.value[0])))
        self.lastAge.accept(Int(floor(slider.value[1])))
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(title)
        title.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.leading.equalTo(self).inset(16)
            $0.top.equalTo(self).inset(13)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

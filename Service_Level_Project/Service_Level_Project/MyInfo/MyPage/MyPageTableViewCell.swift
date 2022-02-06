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
    
    let ageLevel = UILabel().then {
        let lineHeight = $0.setLineHeight(font: .title3_M)
        $0.attributedText = lineHeight
        $0.numberOfLines = 0
        $0.textColor = SacColor.color(.green)
        $0.textAlignment = .left
        $0.font = Font.title3_M14()
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
            let maleButton = ButtonConfiguration(customType: .h48(type: .inactive, icon: false)).then {
                $0.setTitle("남자", for: .normal)
            }
            let femaleButton = ButtonConfiguration(customType: .h48(type: .inactive, icon: false)).then {
                $0.setTitle("여자", for: .normal)
            }
            self.addSubview(maleButton)
            self.addSubview(femaleButton)
            femaleButton.snp.makeConstraints { make in
                make.trailing.equalTo(self).inset(16)
                make.centerY.equalTo(self)
                make.width.equalTo(56)
            }
            maleButton.snp.makeConstraints { make in
                make.trailing.equalTo(femaleButton.snp.leading).offset(-8)
                make.centerY.equalTo(self)
                make.width.equalTo(56)
            }
        } else if indexPath.row == 1 {
            let hobbyTextField = InputText(type: .inactive).then {
                $0.textField.placeholder = "취미를 입력해주세요"
            }
            self.addSubview(hobbyTextField)
            hobbyTextField.snp.makeConstraints { make in
                make.width.equalTo(self.frame.size.width / 2)
                make.trailing.equalTo(self).inset(16)
                make.centerY.equalTo(self).offset(10)
            }
        } else if indexPath.row == 2 {
            let searchSwitch = UISwitch()
            self.addSubview(searchSwitch)
            searchSwitch.snp.makeConstraints { make in
                make.trailing.equalTo(self).inset(16)
                make.centerY.equalTo(self)
            }
        } else if indexPath.row == 3 {

            self.addSubview(ageLevel)
            ageLevel.snp.makeConstraints { make in
                make.trailing.equalTo(self).inset(16)
                make.centerY.equalTo(self)
            }

        } else if indexPath.row == 4 {
            // 연령대 라이브러리
            let slider = MultiSlider().then {
                $0.minimumValue = 18
                $0.maximumValue = 65
                $0.value = [18, 65]
                $0.orientation = .horizontal
                $0.outerTrackColor = SacColor.color(.gray2)
                $0.tintColor = SacColor.color(.green)
                $0.trackWidth = 4
                $0.thumbImage?.withTintColor(.cyan)
                $0.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
            }
            self.addSubview(slider)
            slider.snp.makeConstraints { make in
                make.leading.trailing.equalTo(self).inset(16)
                make.centerY.equalTo(self)
                make.height.equalTo(50)
            }
        }
    }
    
    @objc func sliderChanged(slider: MultiSlider) {
        print("thumb \(slider.draggedThumbIndex) moved")
        print("now thumbs are at \(slider.value)")
        self.startAge.accept(Int(floor(slider.value[0])))
        self.lastAge.accept(Int(floor(slider.value[1])))
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(title)
        title.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.leading.equalTo(self).inset(16)
        }
        
        Observable.combineLatest(self.startAge, self.lastAge)
            .debug("AGE")
            .asDriver(onErrorJustReturn: (0, 60))
            .drive(onNext: { start, last in
                self.ageLevel.text = "\(start) - \(last)"
                print(start)
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

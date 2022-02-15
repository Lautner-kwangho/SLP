//
//  Button+Collection+(2x3).swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/15.
//

import UIKit
import RxSwift

class ButtonSignCollection: UIView {
    
    let firstLeftButton = ButtonConfiguration(customType: .h32(type: .inactive, icon: false)).then {
        $0.setTitle("불법/사기", for: .normal)
    }
    let firstMiddelButton = ButtonConfiguration(customType: .h32(type: .inactive, icon: false)).then {
        $0.setTitle("불편한언행", for: .normal)
    }
    let firstRightButton = ButtonConfiguration(customType: .h32(type: .inactive, icon: false)).then {
        $0.setTitle("노쇼", for: .normal)
    }
    let lastLeftButton = ButtonConfiguration(customType: .h32(type: .inactive, icon: false)).then {
        $0.setTitle("선정성", for: .normal)
    }
    let lastMiddleButton = ButtonConfiguration(customType: .h32(type: .inactive, icon: false)).then {
        $0.setTitle("인신공격", for: .normal)
    }
    let lastRightButton = ButtonConfiguration(customType: .h32(type: .inactive, icon: false)).then {
        $0.setTitle("기타", for: .normal)
    }
    let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 8
    }
    
    let firstStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    let lastStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    convenience init(isEnable touch: Bool) {
        self.init()
        setConstraints()
        bind(touch)
    }
    
    func bind(_ isEnable: Bool) {
        if isEnable {
            [firstLeftButton, firstRightButton, firstMiddelButton, lastMiddleButton, lastLeftButton, lastRightButton].forEach { btn in
                btn.rx.tap
                    .asDriver()
                    .scan(false) { state, _ in
                        !state
                    }
                    .startWith(false)
                    .distinctUntilChanged()
                    .drive(onNext: { status in
                        if status {
                            btn.customLayout(.fill)
                        } else {
                            btn.customLayout(.inactive)
                        }
                    })
                    .disposed(by: disposeBag)
            }
        }
    }
    
    func setConstraints() {

        addSubview(mainStackView)
        mainStackView.addArrangedSubview(firstStackView)
        mainStackView.addArrangedSubview(lastStackView)
        
        mainStackView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
        
        firstStackView.addArrangedSubview(firstLeftButton)
        firstStackView.addArrangedSubview(firstMiddelButton)
        firstStackView.addArrangedSubview(firstRightButton)
        
        lastStackView.addArrangedSubview(lastLeftButton)
        lastStackView.addArrangedSubview(lastMiddleButton)
        lastStackView.addArrangedSubview(lastRightButton)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

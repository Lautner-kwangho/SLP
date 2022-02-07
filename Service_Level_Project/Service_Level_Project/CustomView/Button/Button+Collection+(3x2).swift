//
//  Button+Collection+(3x2).swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/06.
//

import UIKit
import RxSwift

class ButtonCollection: UIView {
    
    let firstLeftButton = ButtonConfiguration(customType: .h32(type: .inactive, icon: false)).then {
        $0.setTitle("좋은 매너", for: .normal)
    }
    let firstRightButton = ButtonConfiguration(customType: .h32(type: .inactive, icon: false)).then {
        $0.setTitle("정확한 시간 약속", for: .normal)
    }
    let middleLeftButton = ButtonConfiguration(customType: .h32(type: .inactive, icon: false)).then {
        $0.setTitle("빠른 응답", for: .normal)
    }
    let middleRightButton = ButtonConfiguration(customType: .h32(type: .inactive, icon: false)).then {
        $0.setTitle("친절한 성격", for: .normal)
    }
    let lastLeftButton = ButtonConfiguration(customType: .h32(type: .inactive, icon: false)).then {
        $0.setTitle("능숙한 취미 실력", for: .normal)
    }
    let lastRightButton = ButtonConfiguration(customType: .h32(type: .inactive, icon: false)).then {
        $0.setTitle("유익한 시간", for: .normal)
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
    let middleStackView = UIStackView().then {
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
            [firstLeftButton, firstRightButton, middleLeftButton, middleRightButton, lastLeftButton, lastRightButton].forEach { btn in
                btn.rx.tap
                    .asDriver()
                    .scan(false) { state, _ in
                        !state
                    }
                    .startWith(false)
                    .distinctUntilChanged()
                    .drive(onNext: { [weak self] status in
                        guard let self = self else { return }
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
        mainStackView.addArrangedSubview(middleStackView)
        mainStackView.addArrangedSubview(lastStackView)
        
        mainStackView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
        
        firstStackView.addArrangedSubview(firstLeftButton)
        firstStackView.addArrangedSubview(firstRightButton)
        
        middleStackView.addArrangedSubview(middleLeftButton)
        middleStackView.addArrangedSubview(middleRightButton)
        
        lastStackView.addArrangedSubview(lastLeftButton)
        lastStackView.addArrangedSubview(lastRightButton)
        
//        firstStackView.snp.makeConstraints {
//            $0.leading.trailing.equalTo(mainStackView)
//        }
//
//        middleStackView.snp.makeConstraints {
//            $0.leading.trailing.equalTo(mainStackView)
//        }
//
//        lastStackView.snp.makeConstraints {
//            $0.leading.trailing.equalTo(mainStackView)
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

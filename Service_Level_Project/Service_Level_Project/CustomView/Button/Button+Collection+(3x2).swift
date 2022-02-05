//
//  Button+Collection+(3x2).swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/06.
//

import UIKit

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
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
        
        firstStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self)
        }
        
        middleStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self)
        }
        
        lastStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

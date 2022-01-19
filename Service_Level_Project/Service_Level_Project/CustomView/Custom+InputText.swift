//
//  Custom+UIButton.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/18.
//

import UIKit

class InputText: UIView {
    lazy var button = UIButton().then {
        $0.setTitle("버튼 제목이 들어갑니다", for: .normal)
        $0.titleLabel?.font = Font.body3_R14()
        $0.backgroundColor = UIColor(named: "green")
        /*
        // 이거까지 구현은 아닌듯 하기도 하고
        // Configuration쓰면 위에서 작성한게 무시되니까 일단 패스
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 30, bottom: 8, trailing: 16)
        configuration.baseBackgroundColor = UIColor(named: "green")
        $0.configuration = configuration
        */
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(button)
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

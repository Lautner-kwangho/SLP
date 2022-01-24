//
//  SelectGenderViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/25.
//

import UIKit

class SelectGenderViewController: AuthBaseViewController {
    // 버튼으로 바꿔서 작업하기 ... 
    let maleView = UIView().then {
        $0.backgroundColor = .blue
    }
    let femaleView = UIView().then {
        $0.backgroundColor = .cyan
    }
    
    let viewModel = SelectGenderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        firstLabel.text = viewModel.Title
        secondLabel.text = viewModel.subTItle
        customButton.setTitle(viewModel.customButtonTitle, for: .normal)
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
        
        view.addSubview(maleView)
        maleView.snp.makeConstraints {
            $0.leading.top.bottom.equalTo(middleView).inset(16)
            $0.width.equalTo(view.frame.width * 0.44)
        }
        
        view.addSubview(femaleView)
        femaleView.snp.makeConstraints {
            $0.trailing.top.bottom.equalTo(middleView).inset(16)
            $0.width.equalTo(view.frame.width * 0.44)
        }
    }
}

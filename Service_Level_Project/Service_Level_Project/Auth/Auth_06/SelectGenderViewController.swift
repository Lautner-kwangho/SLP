//
//  SelectGenderViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/25.
//

import UIKit

class SelectGenderViewController: AuthBaseViewController {
    // 버튼으로 바꿔서 작업하기 ... 
    let maleButton = UIButton(type: .custom).then {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(named: "man")
        configuration.imagePlacement = .top
        configuration.subtitle = "남자"
        configuration.attributedSubtitle?.font = Font.title2_R16()
        configuration.titleAlignment = .center
        configuration.baseBackgroundColor = .clear
        configuration.baseForegroundColor = SacColor.color(.success)
        configuration.background.strokeColor = SacColor.color(.gray3)
        configuration.background.strokeWidth = 1
        configuration.buttonSize = .large
        $0.configuration = configuration
        // configurationUpdateHandler 이용해서 해보려니까 잘 안돼서 그냥 tap이나 action추가해서 해야겠
    }
    let femaleButton = UIButton().then {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(named: "woman")
        configuration.imagePlacement = .top
        configuration.subtitle = "여자"
        configuration.attributedSubtitle?.font = Font.title2_R16()
        configuration.titleAlignment = .center
        configuration.baseBackgroundColor = .clear
        configuration.baseForegroundColor = SacColor.color(.error)
        configuration.background.strokeColor = SacColor.color(.gray3)
        configuration.background.strokeWidth = 1
        configuration.buttonSize = .large
        $0.configuration = configuration
    }
    
    let viewModel = SelectGenderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        firstLabel.text = viewModel.Title
        secondLabel.text = viewModel.subTItle
        customButton.setTitle(viewModel.customButtonTitle, for: .normal)
        maleButton.addTarget(self, action: #selector(maleButtonClicked), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(femaleButtonClicked), for: .touchUpInside)
    }
    
    @objc func maleButtonClicked(_ sender: UIButton) {
        viewModel.maleClicked = !viewModel.maleClicked
        let backgroundColor = viewModel.maleClicked ? SacColor.color(.whitegreen) : .clear
        sender.configuration?.baseBackgroundColor = backgroundColor
    }
    
    @objc func femaleButtonClicked(_ sender: UIButton) {
        viewModel.femaleClicked = !viewModel.femaleClicked
        let backgroundColor = viewModel.femaleClicked ? SacColor.color(.whitegreen) : .clear
        sender.configuration?.baseBackgroundColor = backgroundColor
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
        
        middleView.addSubview(maleButton)
        maleButton.snp.makeConstraints {
            $0.leading.equalTo(middleView).inset(16)
            $0.width.equalTo(view.frame.width * 0.44)
            $0.centerY.equalTo(middleView)
        }
        
        middleView.addSubview(femaleButton)
        femaleButton.snp.makeConstraints {
            $0.trailing.equalTo(middleView).inset(16)
            $0.width.equalTo(view.frame.width * 0.44)
            $0.centerY.equalTo(middleView)
        }
    }
}

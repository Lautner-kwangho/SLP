//
//  ArroundTableCell.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/12.
//

import UIKit

class SearchFriendsTableCell: UITableViewCell {
    // 아이고...
    let test = ["wqe", "test223", "werwer", "wqe", "test223", "werwer"]
    
    let customScrollview = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
    }
    let customStackview = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 10
    }
    
    let cellView = UIView()
    let aroundImage = UIImageView().then {
        $0.image = UIImage(named: "sesac_background_1")
        $0.layer.cornerRadius = 8
    }
    let aroundUserImage = UIImageView().then {
        $0.image = UIImage(named: "sesac_face_1")
    }
    let requestButton = ButtonConfiguration(customType: .h40(type: .fill, icon: false)).then {
        $0.backgroundColor = SacColor.color(.error)
        $0.setTitle("요청하기", for: .normal)
    }
    let aroundView = DimensionHeaderView().then {
        $0.hobbyListStackView.isHidden = false

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cellView)
        cellView.addSubview(aroundImage)
        cellView.addSubview(aroundUserImage)
        cellView.addSubview(requestButton)
        cellView.addSubview(aroundView)
        
        cellView.snp.makeConstraints {
            $0.edges.equalTo(self).inset(16)
        }
        aroundImage.snp.makeConstraints {
            $0.top.equalTo(cellView)
            $0.leading.trailing.equalTo(cellView)
            $0.height.equalTo(194)
        }
        
        aroundUserImage.snp.makeConstraints {
            $0.bottom.equalTo(aroundImage)
            $0.centerX.equalTo(aroundImage)
        }
        
        requestButton.snp.makeConstraints {
            $0.top.equalTo(aroundImage).inset(16)
            $0.trailing.equalTo(aroundImage).inset(16)
        }
        
        aroundView.snp.makeConstraints {
            $0.top.equalTo(aroundImage.snp.bottom)
            $0.leading.trailing.equalTo(cellView)
        }
        
        //MARK: hobby Scroll in customView(aroundView)
        // 다음에는 이렇게 안해야지...
        aroundView.hobbyListStackView.addArrangedSubview(customScrollview)
        customScrollview.snp.makeConstraints { make in
            make.leading.trailing.equalTo(aroundView.hobbyListStackView.safeAreaLayoutGuide)
            make.centerY.equalTo(aroundView.hobbyListStackView)
            make.height.equalTo(40)
        }
        
        customScrollview.addSubview(customStackview)
        customStackview.snp.makeConstraints { make in
            make.top.equalTo(customStackview).inset(5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(customStackview).inset(5)
        }
        
        self.test.forEach { text in
            customStackview.addArrangedSubview(ButtonConfiguration(customType: .h32(type: .inactive, icon: false)).then {
                $0.setTitle("\(text)", for: .normal)
            })
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

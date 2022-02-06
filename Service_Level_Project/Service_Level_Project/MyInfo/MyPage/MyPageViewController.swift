//
//  MyPageViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/25.
//

import UIKit

class MyPageViewController: BaseViewController {
    
    let pageScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    //MARK: 이미지
    let userBackgroudImage = UIImageView().then {
        $0.image = UIImage(named: "sesac_background_1")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
    }
    let userFace = UIImageView().then {
        $0.image = UIImage(named: "sesac_face_1")
    }
    
    //MARK: 오토디멘션 헤더
    let headerView = DimensionHeaderView()
    
    //MARK: 테이블 뷰
    let userTableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.reuseIdentifier)
        $0.isScrollEnabled = false
        $0.separatorColor = .clear
    }
    
    let viewModel = MyPageViewModel()
    
    //MARK: override 부분
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        view.backgroundColor = .white
        
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func setConstraints() {
        view.addSubview(pageScrollView)
        pageScrollView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        pageScrollView.addSubview(userBackgroudImage)
        userBackgroudImage.addSubview(userFace)
        pageScrollView.addSubview(headerView)
        pageScrollView.addSubview(userTableView)
        
        userBackgroudImage.snp.makeConstraints {
            $0.top.equalTo(pageScrollView)
            $0.leading.trailing.equalTo(pageScrollView)
            $0.centerX.equalTo(pageScrollView)
        }
        userFace.snp.makeConstraints {
            $0.bottom.equalTo(userBackgroudImage)
            $0.centerX.equalTo(userBackgroudImage)
        }
        headerView.snp.makeConstraints {
            $0.top.equalTo(userBackgroudImage.snp.bottom)
            $0.leading.trailing.equalTo(pageScrollView)
            $0.centerX.equalTo(pageScrollView)
        }
        
        userTableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(pageScrollView)
            $0.height.equalTo(350)
            $0.bottom.equalTo(pageScrollView)
        }
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.reuseIdentifier, for: indexPath) as? MyPageTableViewCell else {
            return UITableViewCell()
        }

        cell.title.text = "\(viewModel.tableData[indexPath.row].title)"
        cell.selectionStyle = .none
        cell.cellConfigure(indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            print("클릭했음")
        }
    }
    
}

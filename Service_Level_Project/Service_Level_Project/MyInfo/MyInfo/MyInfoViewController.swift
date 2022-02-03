//
//  MyInfoViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/02.
//

import UIKit
import RxSwift

class MyInfoViewController: BaseViewController {
    
    let myInfoTableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(MyInfoCell.self, forCellReuseIdentifier: MyInfoCell.reuseIdentifier)
    }
    
    private lazy var input = MyInfoViewModel
        .Input()
    private lazy var output = viewModel.transform(input: input)
    
    private let viewModel = MyInfoViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         bind()
    }
    
    private func bind() {
        viewModel.list
            .asDriver(onErrorJustReturn: [MyInfoData(image: "에러", title: "에러")])
            .drive(myInfoTableView.rx.items(cellIdentifier: MyInfoCell.reuseIdentifier, cellType: MyInfoCell.self)) { (row, element, cell) in
                cell.cellTitle.text = "\(element.title)"
            }
            .disposed(by: disposeBag)
    }
    
    override func setConstraints() {
        view.addSubview(myInfoTableView)
        myInfoTableView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view)
        }
    }
    
    override func configure() {
        view.backgroundColor = SacColor.color(.white)
        title = viewModel.title
    }
}


//extension MyInfoViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 20
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoCell.reuseIdentifier, for: indexPath) as? MyInfoCell else {
//            return UITableViewCell()
//        }
//
//        return cell
//    }
//}

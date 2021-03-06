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
        $0.register(MyInfoHeaderView.self, forHeaderFooterViewReuseIdentifier: MyInfoHeaderView.reuseIdentifier)
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
            .asDriver(onErrorJustReturn: [])
            .drive(myInfoTableView.rx.items(cellIdentifier: MyInfoCell.reuseIdentifier, cellType: MyInfoCell.self)) { (row, element, cell) in
                cell.cellTitle.text = "\(element.title)"
                cell.cellImage.image = UIImage(named: "\(element.image)")
            }
            .disposed(by: disposeBag)
        
        myInfoTableView.rowHeight = viewModel.tableCellHeight
        myInfoTableView.delegate = self
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
    }
}

extension MyInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyInfoHeaderView.reuseIdentifier) as? MyInfoHeaderView else {
            return UITableViewHeaderFooterView() }
        headerCell.myprofileName.text = output.userNickName
        
        let tapGesture = UITapGestureRecognizer()
        headerCell.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.navigationController?.pushViewController(MyPageViewController(), animated: true)
            })
            .disposed(by: disposeBag)

        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 96
    }
}

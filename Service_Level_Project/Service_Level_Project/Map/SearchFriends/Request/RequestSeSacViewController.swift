//
//  RequestSeSacViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/12.
//

import UIKit
import RxSwift

class RequestSeSacViewController: BaseViewController {

    private let requestStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
    }
    
    let requestTableView = UITableView().then {
        $0.register(SearchFriendsTableCell.self, forCellReuseIdentifier: SearchFriendsTableCell.reuseIdentifier)
    }
    
    private let buttonView = UIView()
    private let changeHobbyButton = ButtonConfiguration(customType: .h48(type: .fill, icon: false)).then {
        $0.setTitle("취미 변경하기", for: .normal)
    }
    private let reloadButton = ButtonConfiguration(customType: .h48(type: .outline, icon: false)).then {
        $0.setImage(UIImage(named: "reload"), for: .normal)
    }
    //MARK: Input & Output
    private lazy var input = RequestSeSacViewModel.Input()
    lazy var output = viewModel.transform(input: input)
    let viewModel = RequestSeSacViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        changeHobbyButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        reloadButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                print("reload button clicked")
            })
            .disposed(by: disposeBag)
    }
    
    override func configure() {
        view.backgroundColor = SacColor.color(.white)
        
        requestTableView.delegate = self
        requestTableView.dataSource = self
    }
    
    override func setConstraints() {
        view.addSubview(requestStackView)
        requestStackView.addArrangedSubview(requestTableView)
        requestStackView.addArrangedSubview(buttonView)
        buttonView.addSubview(changeHobbyButton)
        buttonView.addSubview(reloadButton)
        
        requestStackView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        buttonView.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leading.trailing.equalTo(requestStackView)
        }

        reloadButton.snp.makeConstraints {
            $0.trailing.equalTo(buttonView).inset(16)
            $0.width.equalTo(reloadButton.snp.height)
            $0.centerY.equalTo(buttonView)
        }
        
        changeHobbyButton.snp.makeConstraints {
            $0.leading.equalTo(buttonView).inset(16)
            $0.centerY.equalTo(buttonView)
            $0.trailing.equalTo(reloadButton.snp.leading).inset(-8)
        }
        
    }
}

extension RequestSeSacViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 650
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchFriendsTableCell.reuseIdentifier, for: indexPath) as? SearchFriendsTableCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.requestButton.setTitle("수락하기", for: .normal)
        cell.requestButton.backgroundColor = SacColor.color(.success)
        return cell
    }
    
}

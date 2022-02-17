//
//  AroundSeSacViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/12.
//

import UIKit
import RxSwift
import RxRelay

final class AroundSeSacViewController: BaseViewController {
    
    private let aroundStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
    }
    
    let aroundTableView = UITableView().then {
        $0.register(SearchFriendsTableCell.self, forCellReuseIdentifier: SearchFriendsTableCell.reuseIdentifier)
        $0.backgroundView = TableBackgroundView(text: "아쉽게도 주변에 새싹이 없어요 ㅠ")
    }
    
    private let buttonView = UIView()
    private let changeHobbyButton = ButtonConfiguration(customType: .h48(type: .fill, icon: false)).then {
        $0.setTitle("취미 변경하기", for: .normal)
    }
    private let reloadButton = ButtonConfiguration(customType: .h48(type: .outline, icon: false)).then {
        $0.setImage(UIImage(named: "reload"), for: .normal)
    }
    //MARK: Input & Output
    private lazy var input = AroundSeSacViewModel.Input()
    lazy var output = viewModel.transform(input: input)
    let viewModel = AroundSeSacViewModel()
    let disposeBag = DisposeBag()
    
    private var tableData = [QueueData]()
    private var tableDataCount = BehaviorRelay<Bool>(value: false)
    
    var timer = Timer()
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        checkMyState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.friendsList()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
    
    private func checkMyState() {
        timer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(fiveSecondReqeustMyState), userInfo: nil, repeats: true)
    }
    
    @objc private func fiveSecondReqeustMyState() {
        SeSacURLNetwork.shared.myStatus { model in
            print("반복되는 모델",model)
            if model.matched == 1 {
                self.view.makeToast("\(model.matchedNick)님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다", duration: 1)
                UserDefaults.standard.set(SeSacMapButtonImageManager.imageName(2), forKey: UserDefaultsManager.mapButton)
                self.timer.invalidate()
                let chatView = ChattingViewController()
                chatView.statusData.accept(model)
                self.navigationController?.pushViewController(chatView, animated: true)
            }
        } failErrror: { error in
            guard let error = error else {return}
            print("나 에러: ", error)
            switch error {
            case "201":
                let alertPage = SeSacAlert("친구 찾기 중단","오랜 시간 동안 매칭 되지 않아 새싹 친구 찾기를 그만둡니다") {
                    self.timer.invalidate()
                    self.dismiss(animated: true)
                }
                alertPage.cancelButton.isHidden = true
                alertPage.modalPresentationStyle = .overFullScreen
                self.present(alertPage, animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
    func bind() {
        changeHobbyButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else {return}
                SeSacURLNetwork.shared.friendsRequestStop {
                    self.navigationController?.popViewController(animated: true)
                } failErrror: { errorCode in
                    guard let code = errorCode else {return}
                    switch code {
                    case "201":
                        let alertPage = SeSacAlert("나갈거에요?", "엇..이미 매칭되어 있는 상태입니다") {
                            self.dismiss(animated: true)
                        }
                        alertPage.cancelButton.isHidden = true
                        alertPage.modalPresentationStyle = .overFullScreen
                        self.present(alertPage, animated: true, completion: nil)
                    default:
                        break
                    }
                }
            })
            .disposed(by: disposeBag)
        
        reloadButton.rx.tap
            .debounce(.seconds(5), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: print("그만좀눌러ㅡㅡ"))
            .drive(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.viewModel.friendsList()
            })
            .disposed(by: disposeBag)
        
        viewModel.friendsList()
        
        output.fromData.asSignal()
            .emit(onNext: { [weak self] model in
                guard let self = self else {return}
                self.tableData = []
                model.forEach { data in
                    self.tableDataCount.accept(false)
                    guard let data = data else {return}
                    self.tableData.append(data)
                    self.tableDataCount.accept(true)
                }
                print("주변데이터 : ", self.tableData)
                self.aroundTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    override func configure() {
        view.backgroundColor = SacColor.color(.white)
        
        aroundTableView.delegate = self
        aroundTableView.dataSource = self
    }
    
    override func setConstraints() {
        view.addSubview(aroundStackView)
        aroundStackView.addArrangedSubview(aroundTableView)
        aroundStackView.addArrangedSubview(buttonView)
        buttonView.addSubview(changeHobbyButton)
        buttonView.addSubview(reloadButton)
        
        aroundStackView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        buttonView.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leading.trailing.equalTo(aroundStackView)
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

        tableDataCount.asDriver()
            .drive(onNext: { [weak self] status in
                guard let self = self else {return}
                self.aroundTableView.backgroundView?.isHidden = status
                self.buttonView.isHidden = status
            })
            .disposed(by: disposeBag)
    }
}

extension AroundSeSacViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 650
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchFriendsTableCell.reuseIdentifier, for: indexPath) as? SearchFriendsTableCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        cell.requestButton.tag = indexPath.row
        cell.requestButton.addTarget(self, action: #selector(clickedRequest(_:)), for: .touchUpInside)
        
        let data = self.tableData[indexPath.row]
        cell.aroundImage.image = SeSacUserBackgroundImageManager.image(data.background)
        cell.aroundUserImage.image = SeSacUserImageManager.image(data.sesac)
        cell.aroundView.userNickname.text = data.nick
        
        let repuFilter = data.reputation.map { $0 > 0 ? ButtonCase.fill : ButtonCase.inactive }
        
        cell.aroundView.userTitleButton.firstLeftButton.customLayout(repuFilter[0])
        cell.aroundView.userTitleButton.firstLeftButton.customLayout(repuFilter[1])
        cell.aroundView.userTitleButton.firstLeftButton.customLayout(repuFilter[2])
        cell.aroundView.userTitleButton.firstLeftButton.customLayout(repuFilter[3])
        cell.aroundView.userTitleButton.firstLeftButton.customLayout(repuFilter[4])
        cell.aroundView.userTitleButton.firstLeftButton.customLayout(repuFilter[5])
        DispatchQueue.global().sync {
            var hobby = [String]()
            data.hf.forEach { text in
                if text.lowercased() == "anything" {
                    hobby.append("아무거나")
                } else {
                    hobby.append(text)
                }
            }
            print("취미 활동 확인하기 \(indexPath.row): ", hobby)
            cell.addButtonTitle.accept(hobby)
        }
        
        let review = data.reviews.first == nil ? "첫 리뷰를 기다리는 중이에요" : data.reviews.first
        cell.aroundView.userReview.text = review
        
        let status = review != "첫 리뷰를 기다리는 중이에요" ? true : false
        cell.moreReviewButton.isHidden = !status
        
        cell.moreReviewButton.tag = indexPath.row
        cell.moreReviewButton.addTarget(self, action: #selector(clickedButton(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func clickedRequest(_ sender: UIButton) {
        let buttonTag = sender.tag
        let data = self.tableData[buttonTag]
        let alertPage = SeSacAlert("취미 같이 하기를 요청할게요!", "요청이 수락되면 30분 후에 리뷰를 남길 수 있어요") {
            SeSacURLNetwork.shared.myStatus { model in
                print("나 주변 보낸 모델이야", model)
                if model.matched == 1 {
                    self.view.makeToast("채팅방으로 이동합니다", duration: 1)
                    UserDefaults.standard.set(SeSacMapButtonImageManager.imageName(2), forKey: UserDefaultsManager.mapButton)
                    let chatView = ChattingViewController()
                    chatView.statusData.accept(model)
                    self.navigationController?.pushViewController(chatView, animated: true)
                } else {
                    SeSacURLNetwork.shared.hobbyRequest(userID: data.uid) {
                        self.view.makeToast("취미 함께 하기 요청을 보냈습니다")
                    } failErrror: { error in
                        guard let code = error else {return}
                        switch code {
                        case "201":
                            SeSacURLNetwork.shared.hobbyAccept(userID: data.uid) {
                                self.view.makeToast("상대방도 취미 함께 하기를 요청했습니다. 채팅방으로 이동합니다")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    let chatView = ChattingViewController()
                                    chatView.otherUid.accept(data.uid)
                                    self.navigationController?.pushViewController(chatView, animated: true)
                                }
                            } failErrror: { _ in
                            }
                        case "202":
                            self.view.makeToast("상대방이 취미 함께 하기를 그만두었습니다")
                        default:
                            break
                        }
                    }
                }
            } failErrror: { errorcode in
                guard let code = errorcode else {return}
                print("나 주변 보낸 모델이야", code)
                if code == "201" {
                    self.view.makeToast("오랜 시간 동안 매칭 되지 않아 새싹 친구 찾기를 그만둡니다", duration: 1)
                    UserDefaults.standard.set(SeSacMapButtonImageManager.imageName(0), forKey: UserDefaultsManager.mapButton)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }

            self.dismiss(animated: true)
        }
        alertPage.modalPresentationStyle = .overFullScreen
        self.present(alertPage, animated: true, completion: nil)
    }
    
    @objc func clickedButton(_ sender: UIButton) {
        let buttonTag = sender.tag
        let data = self.tableData[buttonTag]
        let reviewView = ReviewViewController()
        reviewView.reviewList = data.reviews
        self.navigationController?.pushViewController(reviewView, animated: true)
    }
    
}

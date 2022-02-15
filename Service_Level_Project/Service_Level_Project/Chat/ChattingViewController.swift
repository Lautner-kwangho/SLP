//
//  ChattingViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/13.
//

import UIKit

import RxSwift
import RxRelay
import RxKeyboard

final class ChattingViewController: BaseViewController {
    
    lazy var backButton = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: #selector(backButtonClicked))
    
    lazy var moreButton = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(moreButtonClicked))
    
    let animateView = UIView().then {
        $0.isHidden = true
        $0.clipsToBounds = true
    }
    let moreStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.backgroundColor = SacColor.color(.white)
        $0.clipsToBounds = true
    }
    let reportButton = UIButton(configuration: .plain(), primaryAction: nil).then {
        var configuaration = UIButton.Configuration.plain()
        configuaration.image = UIImage(named: "siren")
        configuaration.imagePlacement = .top
        configuaration.title = "새싹 신고"
        configuaration.attributedTitle?.font = Font.title3_M14()
        configuaration.baseForegroundColor = SacColor.color(.black)
        configuaration.titlePadding = 10
        $0.configuration = configuaration
    }
    let cancelButton = UIButton(configuration: .plain(), primaryAction: nil).then {
        var configuaration = UIButton.Configuration.plain()
        configuaration.image = UIImage(named: "cancel_match")
        configuaration.imagePlacement = .top
        configuaration.title = "약속 취소"
        configuaration.attributedTitle?.font = Font.title3_M14()
        configuaration.baseForegroundColor = SacColor.color(.black)
        configuaration.titlePadding = 10
        $0.configuration = configuaration
    }
    let reviewButton = UIButton(configuration: .plain(), primaryAction: nil).then {
        var configuaration = UIButton.Configuration.plain()
        configuaration.image = UIImage(named: "write")
        configuaration.imagePlacement = .top
        configuaration.title = "리뷰 등록"
        configuaration.attributedTitle?.font = Font.title3_M14()
        configuaration.baseForegroundColor = SacColor.color(.black)
        configuaration.titlePadding = 10
        $0.configuration = configuaration
    }
    let moreBackgroundView = UIView().then {
        $0.backgroundColor = SacColor.color(.gray6)
        $0.alpha = 0.5
        $0.isHidden = true
    }
    
    let chatTableView = UITableView().then {
        $0.register(ReceiveChatTableViewCell.self, forCellReuseIdentifier: ReceiveChatTableViewCell.reuseIdentifier)
        $0.register(SendChatTableViewCell.self, forCellReuseIdentifier: SendChatTableViewCell.reuseIdentifier)
        $0.register(ChattingHeaderView.self, forCellReuseIdentifier: ChattingHeaderView.reuseIdentifier)
        $0.separatorColor = .clear
    }
    
    let chatInputView = UIView().then {
        $0.backgroundColor = SacColor.color(.gray1)
        $0.layer.cornerRadius = 8
    }
    let chatInputTextView = UITextView().then {
        $0.backgroundColor = .clear
        $0.text = "메시지를 입력해주세요"
        $0.textColor = SacColor.color(.gray7)
        $0.sizeToFit()
    }
    let chatInputSendButton = UIButton().then {
        $0.setImage(UIImage(named: "arrow.sesac"), for: .normal)
        $0.isEnabled = false
    }
    
    //MARK: Input & Output
    let disposeBag = DisposeBag()
    
    var tempChatData = [TempRealmModel]()
    
    var otherUID = String()
    var otherNICK = String()
    var otherUid = PublishRelay<String>()
    var statusData = PublishRelay<SeSacStateModel>()
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        socketConnect()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        otherUid.asSignal()
            .emit(onNext: { [weak self] text in
                guard let self = self else {return}
                print("other UID :", text)
                SeSacURLNetwork.shared.myStatus { model in
                    self.statusData.accept(model)
                } failErrror: { errorCode in
                    guard let error = errorCode else {return}
                    if error == "201" {
                        self.view.makeToast("오랜 시간 동안 매칭 되지 않아 새싹 친구 찾기를 그만둡니다", duration: 1)
                        UserDefaults.standard.set(SeSacMapButtonImageManager.imageName(0), forKey: UserDefaultsManager.mapButton)
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }

            })
            .disposed(by: disposeBag)
        
        statusData.asSignal()
            .emit(onNext: { [weak self] model in
                guard let self = self else {return}
                self.title = model.matchedNick
                self.otherUID = model.matchedUid
                self.otherNICK = model.matchedNick
                if model.dodged == 1 || model.reviewed == 1 {
                    self.view.makeToast("약속이 종료되어 채팅을 보낼 수 없습니다")
                } else {
                    SocketIOMananger.shared.establishConnection()
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SocketIOMananger.shared.closeConnection()
    }
    
    private func socketConnect() {
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification:)), name: Notification.Name(NotificationCenterName.getMessage), object: nil)
    }
    
    @objc private func getMessage(notification: NSNotification) {
        
    }
    
    private func bind() {
        chatInputSendButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else {return}
                SeSacURLNetwork.shared.sendChat(uid: self.otherUID, sendMessage: self.chatInputTextView.text) { model in
                    // 🍎 보내는 거
                    let tempData = TempRealmModel(friendsUid: model.to, myUid: model.from, chat: model.chat, createAt: model.createdAt)
                    self.tempChatData.append(tempData)
                    self.chatTableView.reloadData()
                    // 여기 스크롤도 해줘야 한다ㅏㅏㅏㅏ 잊지 말기ㅣㅣㅣㅣㅣ
                    
                } failErrror: { errorCode in
                    guard let code = errorCode else {return}
                    if code == "201" {
                        self.view.makeToast("약속이 종료되어 채팅을 보낼 수 없습니다", position: .center)
                    }
                }
                self.chatInputTextView.text = ""
            })
            .disposed(by: disposeBag)
        // 버튼 기능 구현
        reportButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else {return}
                let alertPage = SeSacTextViewAlert("새싹 신고", "다시는 해당 새싹과 매칭되지 않습니다", "신고 사유를 적어주세요\n허위 신고 시 제재를 받을 수 있습니다") {
                    self.dismiss(animated: true)
                    // 신고 기능 구현 예정
                }
                alertPage.modalPresentationStyle = .overFullScreen
                self.present(alertPage, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else {return}
                let alertPage = SeSacAlert("약속을 취소하겠습니까?", "약속을 취소하시면 패널티가 부과됩니다") {
                    self.dismiss(animated: true)
                    // 약속 취소 네트워크 구현 예정
                }
                alertPage.modalPresentationStyle = .overFullScreen
                self.present(alertPage, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        reviewButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else {return}
                let alertPage = SeSacTextViewAlert("리뷰 등록", "\(self.otherNICK)님과의 취미 활동은 어떠셨나요?", "자세한 피드백은 다른 새싹들에게도 도움이 됩니다 (500자 이내 작성)") {
                    self.dismiss(animated: true)
                    // 리뷰 기능 구현 예정
                }
                alertPage.modalPresentationStyle = .overFullScreen
                self.present(alertPage, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    override func configure() {
        view.backgroundColor = SacColor.color(.white)
        
        chatInputTextView.delegate = self
        
        // navigation bar Setting
        touchManager()
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = moreButton
        self.navigationController?.navigationBar.backgroundColor = SacColor.color(.white)
        self.navigationController?.navigationBar.tintColor = SacColor.color(.black)
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.sectionHeaderHeight = UITableView.automaticDimension
    }
    
    override func setConstraints() {
        view.addSubview(chatTableView)
        view.addSubview(chatInputView)
        chatInputView.addSubview(chatInputTextView)
        chatInputView.addSubview(chatInputSendButton)
        
        chatInputView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(52)
        }
        
        chatInputTextView.snp.makeConstraints {
            $0.leading.equalTo(chatInputView).inset(12)
            $0.top.bottom.equalTo(chatInputView).inset(14)
            $0.width.equalTo(view.frame.width * 0.8)
        }
        
        chatInputSendButton.snp.makeConstraints {
            $0.centerY.equalTo(chatInputView)
            $0.trailing.equalTo(chatInputView).inset(14)
            $0.width.equalTo(20)
            $0.height.equalTo(chatInputSendButton.snp.width)
        }
        
        chatTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(chatInputView.snp.top).inset(-16)
        }
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { [weak self] keyboardHeight in
                guard let self = self else {return}
                if keyboardHeight > 0 {
                    UIView.animate(withDuration: 1) {
                        self.chatInputView.snp.updateConstraints {
                            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeight - 34)
                        }
                        DispatchQueue.main.async {
                            self.chatTableView.snp.updateConstraints {
                                $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
                                $0.bottom.equalTo(self.chatInputView.snp.top).inset(-16)
                            }
                            self.chatTableView.scrollToRow(at: IndexPath(row: 9, section: 1), at: .bottom, animated: false)
                        }
                        
                    }
                } else {
                    UIView.animate(withDuration: 1) {
                        self.chatInputView.snp.updateConstraints {
                            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
                        }
                        self.chatTableView.scrollToRow(at: IndexPath(row: 9, section: 1), at: .bottom, animated: false)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        // Navigation Constraints
        view.addSubview(animateView)
        view.addSubview(moreBackgroundView)
        animateView.addSubview(moreStackView)
        moreStackView.addArrangedSubview(reportButton)
        moreStackView.addArrangedSubview(cancelButton)
        moreStackView.addArrangedSubview(reviewButton)
        
        animateView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        moreStackView.snp.makeConstraints {
            $0.top.equalTo(animateView.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(animateView.safeAreaLayoutGuide)
            $0.height.equalTo(72)
        }
        
        moreBackgroundView.snp.makeConstraints {
            $0.top.equalTo(moreStackView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(animateView.safeAreaLayoutGuide)

        }
        
        animateView.center.y -= view.bounds.height
    }
    
    @objc private func backButtonClicked(_ sender: Any) {
        UserDefaults.standard.set(SeSacMapButtonImageManager.imageName(2), forKey: UserDefaultsManager.mapButton)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func moreButtonClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.animateView.isHidden = false
            self.animateView.center.y += self.view.bounds.height + 10
        } completion: { _ in
            self.moreBackgroundView.isHidden = false
            self.moreButton.isEnabled = false
        }
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
        animateView.isHidden = true
        animateView.center.y -= view.bounds.height
        moreBackgroundView.isHidden = true
        self.moreButton.isEnabled = true
    }
    
    private func touchManager() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.moreBackgroundView.addGestureRecognizer(tap)
    }
}

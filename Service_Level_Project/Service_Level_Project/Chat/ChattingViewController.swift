//
//  ChattingViewController.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/13.
//

import UIKit

class ChattingViewController: BaseViewController {
    
    lazy var backButton = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: #selector(backButtonClicked))
    
    lazy var stopButton = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(moreButtonClicked))
    
    let chatTableView = UITableView().then {
        $0.register(ReceiveChatTableViewCell.self, forCellReuseIdentifier: ReceiveChatTableViewCell.reuseIdentifier)
        $0.register(SendChatTableViewCell.self, forCellReuseIdentifier: SendChatTableViewCell.reuseIdentifier)
        $0.register(ChattingHeaderView.self, forHeaderFooterViewReuseIdentifier: ChattingHeaderView.reuseIdentifier)
        $0.separatorColor = .clear
    }
    
    let chatInputView = UIView().then {
        $0.backgroundColor = SacColor.color(.gray1)
        $0.layer.cornerRadius = 8
    }
    let chatInputTextView = UITextView().then {
        $0.backgroundColor = SacColor.color(.error)
        $0.text = "메시지를 입력해주세요"
        $0.sizeToFit()
    }
    let chatInputSendButton = UIButton().then {
        $0.setImage(UIImage(named: "arrow.sesac.fill"), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        view.backgroundColor = SacColor.color(.white)
        self.title = "매칭 유저 이름"
        
        // navigation bar Setting
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = stopButton
        self.navigationController?.navigationBar.backgroundColor = SacColor.color(.white)
        self.navigationController?.navigationBar.tintColor = SacColor.color(.black)
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.rowHeight = UITableView.automaticDimension
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
    }
    
    @objc private func backButtonClicked(_ sender: Any) {
        print("뒤로 가기 버튼 클리")
    }
    
    @objc private func moreButtonClicked(_ sender: Any) {
        print("더보기 버튼 클릭")
    }
}

extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChattingHeaderView.reuseIdentifier) as? ChattingHeaderView else {return UITableViewHeaderFooterView()}
        headerView.backgroundColor = .green
        return headerView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            guard let receiveCell = tableView.dequeueReusableCell(withIdentifier: ReceiveChatTableViewCell.reuseIdentifier, for: indexPath) as? ReceiveChatTableViewCell else {return UITableViewCell()}
            receiveCell.selectionStyle = .none
            
            
            
            return receiveCell
        } else {
            guard let sendCell = tableView.dequeueReusableCell(withIdentifier: SendChatTableViewCell.reuseIdentifier, for: indexPath) as? SendChatTableViewCell else {return UITableViewCell()}
            sendCell.selectionStyle = .none





            return sendCell
        }
    }
    
    
}

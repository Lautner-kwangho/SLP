//
//  ChatTableView+Extension.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/14.
//

import UIKit

extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = section == 0 ? 1 : 10
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let headCell = tableView.dequeueReusableCell(withIdentifier: ChattingHeaderView.reuseIdentifier, for: indexPath) as? ChattingHeaderView else {return UITableViewCell()}
            self.statusData.asSignal()
                .emit(onNext: { model in
                    headCell.chatTitle.text = "\(model.matchedNick) 유저와 매칭되었습니다"
                })
                .disposed(by: disposeBag)
            
            return headCell
        } else {
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
    
}

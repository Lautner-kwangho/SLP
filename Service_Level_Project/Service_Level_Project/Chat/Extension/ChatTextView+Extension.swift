//
//  ChatTextView+Extension.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/14.
//

import UIKit

extension ChattingViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "메시지를 입력해주세요" {
            textView.text = ""
        }
        textView.textColor = SacColor.color(.black)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            textView.text = "메시지를 입력해주세요"
            textView.textColor = SacColor.color(.gray7)
        } else {
            textView.textColor = SacColor.color(.black)
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width * 0.8, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        if textView.numberOfLine() < 4 {
            chatInputView.snp.updateConstraints { make in
                make.height.equalTo(estimatedSize.height+28)
            }
        }
        
        if textView.text.count > 0 {
            chatInputSendButton.setImage(UIImage(named: "arrow.sesac.fill"), for: .normal)
        } else {
            chatInputSendButton.setImage(UIImage(named: "arrow.sesac"), for: .normal)
        }
    }
}

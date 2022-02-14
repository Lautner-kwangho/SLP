//
//  UITextView+Extension.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/14.
//

import UIKit

extension UITextView {
    // 라인 수 구하기
    func numberOfLine() -> Int {
        let size = CGSize(width: frame.width, height: frame.height)
        let estimatedSize = sizeThatFits(size)
        
        return Int(estimatedSize.height / (self.font!.lineHeight))
    }
}

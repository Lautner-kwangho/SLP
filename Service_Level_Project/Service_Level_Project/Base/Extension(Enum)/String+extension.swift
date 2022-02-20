//
//  String+extension.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/20.
//

import Foundation

extension String {
    // 글자 범위 구간 찾기
    func subString(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }
        
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1)
        
        return String(self[startIndex ..< endIndex])
    }
    
    // 글자 뽑아내기(날짜)
    func subDateString() -> String {
        let searchStr = self.range(of: "T")
        let range = self.distance(from: self.startIndex, to: searchStr!.lowerBound)
        let convertDate = self.subString(from: range + 1, to: range + 5)
        
        return convertDate
    }
}

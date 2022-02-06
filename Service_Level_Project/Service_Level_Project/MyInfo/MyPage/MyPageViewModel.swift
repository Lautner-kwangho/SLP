//
//  MyPageViewModel.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/06.
//

import Foundation

struct MyPageData {
    var title: String
}

final class MyPageViewModel {
    
    var tableData = [
        MyPageData(title: "내 성별"),
        MyPageData(title: "자주하는 취미"),
        MyPageData(title: "내 번호 검색 허용"),
        MyPageData(title: "상대방 연령대"),
        MyPageData(title: "회원탈퇴")
    ]
    
    
}

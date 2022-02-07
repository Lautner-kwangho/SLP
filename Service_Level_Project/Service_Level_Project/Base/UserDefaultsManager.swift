//
//  UserDefaultsManager.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/01.
//

import Foundation
import Alamofire
import Firebase

class UserDefaultsManager {
    static let idToken = "idToken"
    static let authIdToken = "authIdToken"
    static let fcmToken = "fcmToken"
    static let phoneNumber = "PhoneNumber"
    static let nickname = "nickname"
    static let birthday = "birthday"
    static let email = "email"
    static let gender = "gender"
}


//MARK: refresh해줘야 하는데 저렇게 적어놓으니까 너무 더럽 (내 정보 회원탈퇴부터 적용)
final class checkSesacNetWork: RequestInterceptor {
    // 재실행 여부 확인
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if request.response?.statusCode == 401 {
            let currentUser = Auth.auth().currentUser
            currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                guard let idToken = idToken else { return }
                UserDefaults.standard.set(idToken, forKey: UserDefaultsManager.authIdToken)
            }
            completion(.retry)
        } else {
            completion(.doNotRetry)
        }
    }
    
    // 네트워크 요청하기 전에 실행(매번 실행은 아닌듯)
//    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
//
//    }
}

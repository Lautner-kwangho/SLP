//
//  SeSacURLNetwork.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/03.
//

import Foundation
import Alamofire
import Firebase

class SeSacURLNetwork {
    
    static let shared = SeSacURLNetwork()
    
    let formatter = DateFormatter()
    let birthday = UserDefaults.standard.string(forKey: UserDefaultsManager.birthday)!
    
    func registMember(successData: @escaping (AFDataResponse<Data>?) -> (), failErrror: @escaping (String?) -> ()) {
        let URL = Point.regist.url

        let header: HTTPHeaders = [
            "idtoken" : UserDefaults.standard.string(forKey: UserDefaultsManager.authIdToken)!,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ko-KR")
        formatter.timeZone = .autoupdatingCurrent
        let birthdayFormat = formatter.date(from: birthday)
        
        let parameter = [
            "phoneNumber" : UserDefaults.standard.string(forKey: UserDefaultsManager.phoneNumber)!,
            "FCMtoken" : UserDefaults.standard.string(forKey: UserDefaultsManager.fcmToken)!,
            "nick": UserDefaults.standard.string(forKey: UserDefaultsManager.nickname)!,
            "birth": "\(birthdayFormat!)",
            "email": UserDefaults.standard.string(forKey: UserDefaultsManager.email)!,
            "gender" : UserDefaults.standard.string(forKey: UserDefaultsManager.gender)!
        ]
        
        let dataRequest = AF.request(URL, method: .post, parameters: parameter, headers: header).validate(statusCode: 200...200)
            
        dataRequest.responseData { response in
            switch response.result {
            case .success:
                successData(response)
            case let .failure(error):
                guard let errorCode = error.responseCode else { return }
                let status = self.checkError(errorCode)
                if errorCode == 401 {
                    dataRequest.responseData { response in
                        switch response.result {
                        case .success:
                            successData(response)
                        case .failure(let error):
                            guard let errorCode = error.responseCode else { return }
                            let status = self.checkError(errorCode)
                            failErrror(status)
                        }
                    }
                }
                failErrror(status)
            }
        }
    }
    
    func loginMember(successData: @escaping (SeSacLoginModel?) -> (), failErrror: @escaping (String?) -> ()) {
        let URL = Point.regist.url
        let header: HTTPHeaders = [
            "idtoken" : UserDefaults.standard.string(forKey: UserDefaultsManager.authIdToken)!,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let dataRequest = AF.request(URL, method: .get, headers: header).validate(statusCode: 200...200)
        
        dataRequest.responseData { response in
            switch response.result {
            case let .success(value):
                guard let data = response.value else { return }
                let decoder = JSONDecoder()
                let json = try? decoder.decode(SeSacLoginModel.self, from: data)
                print("디버그 :",json.debugDescription)
                
                successData(json)
            case let .failure(error):
                guard let errorCode = error.responseCode else { return }
                let status = self.checkError(errorCode)
                if errorCode == 401 {
                    dataRequest.responseData { response in
                    }
                }
                failErrror(status)
            }
        }
    }
    
    private func checkError(_ errorCode: Int) -> String{
        switch errorCode {
        case 201:
            return "201"
        case 202:
            return "202"
        case 401:
            return updateToken()
        case 406:
            return "406"
        case 500:
            return "Server Error"
        case 501:
            return "client Error"
        default:
            return "Known error"
        }
    }
    
    private func updateToken() -> String {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            guard let idToken = idToken else { return }
            UserDefaults.standard.set(idToken, forKey: UserDefaultsManager.authIdToken)
        }
        return "401"
    }
}

//
//  SeSacURLNetwork.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/02/03.
//

import Foundation
import Alamofire
import Firebase
import RxSwift

class SeSacURLNetwork {
    
    static let shared = SeSacURLNetwork()
    
    let formatter = DateFormatter()
    let birthday = UserDefaults.standard.string(forKey: UserDefaultsManager.birthday)!
    
    // 1차 작업
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
    
    // 1차 작업
    func loginMember(successData: @escaping (SeSacLoginModel?) -> (), failErrror: @escaping (String?) -> ()) {
        let URL = Point.regist.url
        let header: HTTPHeaders = [
            "idtoken" : UserDefaults.standard.string(forKey: UserDefaultsManager.authIdToken)!,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let dataRequest = AF.request(URL, method: .get, headers: header, interceptor: checkSesacNetWork()).validate(statusCode: 200...200)
        
        dataRequest.responseData { response in
            switch response.result {
            case .success:
                guard let data = response.value else { return }
                let decoder = JSONDecoder()
                let json = try? decoder.decode(SeSacLoginModel.self, from: data)
                guard let json = json else {return}
                
                DispatchQueue.global().sync {
                    MyInfoViewModel.myData.accept(json)
                    print("메인", json)
                }
        
                successData(json)
            case let .failure(error):
                guard let errorCode = error.responseCode else { return }
                let status = self.checkError(errorCode)
                
                failErrror(status)
            }
        }
    }
    // 2차 작업 : 3차요청에서는 조금 더 반복된 내용 줄여서 사용하면 될 거 같은데
    func withdraw() {
        let URL = Point.withdraw.url
        let header: HTTPHeaders = [
            "idtoken" : UserDefaults.standard.string(forKey: UserDefaultsManager.authIdToken)!,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let withdrawRequest = AF.request(URL, method: .post, headers: header, interceptor: checkSesacNetWork()).validate(statusCode: 200...200)
            
            withdrawRequest.responseData { response in
            switch response.result {
            case .success(_):
                guard let data = response.value else { return }
            case let .failure(error):
                guard let errorCode = error.responseCode else { return }
                let status = self.checkError(errorCode)
                print(status)
            }
        }
    }
    // 2차 작업
    func updateMypage(search: Int, ageMin: Int, ageMax: Int, gender: Int, hobby: String) {
        let URL = Point.updateMypage.url
        let header: HTTPHeaders = [
            "idtoken" : UserDefaults.standard.string(forKey: UserDefaultsManager.authIdToken)!,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        let parameter: Parameters = [
            "searchable" : search,
            "ageMin" : ageMin,
            "ageMax" : ageMax,
            "gender" : gender,
            "hobby" : hobby
        ]
        
        AF.request(URL, method: .post, parameters: parameter, headers: header, interceptor: checkSesacNetWork()).validate(statusCode: 200...200)
            .responseData { response in
                switch response.result {
                case .success:
                    print("성공",response.response?.statusCode)
                case let .failure(error):
                    print("실패", error)
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

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
                    UserDefaults.standard.set(json.gender, forKey: UserDefaultsManager.gender)
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
    
    // 3차 작업
    static func callNetwork(url: URL, parameter: Parameters?, method: HTTPMethod, handler: @escaping (AFDataResponse<Data>) -> Void) {
        let URL = url
        let header: HTTPHeaders = [
            "idtoken" : UserDefaults.standard.string(forKey: UserDefaultsManager.authIdToken)!,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let parameter: Parameters? = parameter
        AF.request(URL, method: method, parameters: parameter, headers: header, interceptor: checkSesacNetWork() ).validate(statusCode: 200...200).responseData(completionHandler: handler)
    }
    
    // 취미 친구 찾기
    func friendsRequest(hf: [String], successData: @escaping () -> (), failErrror: @escaping (String?) -> ()) {
        let typeFilter = UserDefaults.standard.integer(forKey: UserDefaultsManager.gender) == -1 ? -1 : 2
        let hfFilter = hf.count > 0 ? hf : ["Anything"]
        
        let URL = Point.mapRequestFriends.url
        let header: HTTPHeaders = [
            "idtoken" : UserDefaults.standard.string(forKey: UserDefaultsManager.authIdToken)!,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let parameter: Parameters = [
          "type": typeFilter,
          "region": UserDefaults.standard.integer(forKey: UserDefaultsManager.region),
          "long": UserDefaults.standard.double(forKey: UserDefaultsManager.longitude),
          "lat": UserDefaults.standard.double(forKey: UserDefaultsManager.latitude),
          "hf": hfFilter
        ]
        
        AF.request(URL, method: .post, parameters: parameter, encoding: URLEncoding(arrayEncoding: .noBrackets), headers: header, interceptor: checkSesacNetWork()).validate(statusCode: 200...200).responseData { response in
            switch response.result {
            case .success:
                print("성공", response.response?.statusCode)
                successData()
            case let .failure(error):
                guard let errorCode = error.responseCode else { return }
                print(errorCode)
                let status = self.checkError(errorCode)
                failErrror(status)
            }
        }
    }

    // 취미 친구 중단
    func friendsRequestStop(successData: @escaping () -> (), failErrror: @escaping (String?) -> ()) {
        let URL = Point.mapRequestFriends.url

        SeSacURLNetwork.callNetwork(url: URL, parameter: nil, method: .delete) { response in
            switch response.result {
            case .success:
                successData()
            case let .failure(error):
                guard let errorCode = error.responseCode else { return }
                print(errorCode)
                let status = self.checkError(errorCode)
                failErrror(status)
            }
        }
    }
    
    // 취미 함께할 친구 검색 (메인 맵 페이지)
    static func friendsWithMe(region: Int, latitude: Double, longitude: Double) {
        let URL = Point.mapFindFriends.url
        // 현재 위치 잡기
        let parameter = [
            "region": "\(region)",
            "lat": "\(latitude)",
            "long": "\(longitude)"
        ]
        SeSacURLNetwork.callNetwork(url: URL, parameter: parameter, method: .post) { response in
            switch response.result {
            case .success(let success):
                guard let data = response.value else { return }
                let decoder = JSONDecoder()
                let json = try? decoder.decode(SeSacSearchFreindsModel.self, from: data)
                guard let json = json else {return}
                MapViewModel.myData.accept(json)
                AroundSeSacViewModel.myData.accept(json)
                RequestSeSacViewModel.myData.accept(json)
            case let .failure(error):
                print("실패", error)
            }
        }
    }
    
    
    private func checkError(_ errorCode: Int) -> String {
        switch errorCode {
        case 201:
            return "201"
        case 202:
            return "202"
        case 203:
            return "203"
        case 204:
            return "204"
        case 205:
            return "205"
        case 206:
            return "206"
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

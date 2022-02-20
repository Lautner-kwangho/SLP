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
import SocketIO

class SeSacURLNetwork {
    
    static let shared = SeSacURLNetwork()
    
    let formatter = DateFormatter()
    
    //fcm 토큰 갱신 : 홈화면 들어와서 흠...
    func updateFCMToken() {
        let URL = Point.updateFCMToken.url
        guard let fcmToken = UserDefaults.standard.string(forKey: UserDefaultsManager.fcmToken) else { return }
        let parameter = [
            "FCMtoken": "\(fcmToken)"
        ]
        SeSacURLNetwork.callNetwork(url: URL, parameter: parameter, method: .put) { response in
            switch response.result {
            case .success:
                print("토큰 업데이트 성공")
            case let .failure(error):
                guard let errorCode = error.responseCode else { return }
                print("토큰 업데이트 실패: ", errorCode)
            }
        }
    }
    
    // 1차 작업
    func registMember(successData: @escaping (AFDataResponse<Data>?) -> (), failErrror: @escaping (String?) -> ()) {
        let URL = Point.regist.url
        let birthday = UserDefaults.standard.string(forKey: UserDefaultsManager.birthday)!
        
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
        guard let idtoken = UserDefaults.standard.string(forKey: UserDefaultsManager.authIdToken) else {return}
        let header: HTTPHeaders = [
            "idtoken" : "\(idtoken)",
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
    func withdraw(successData: @escaping () -> ()) {
        let URL = Point.withdraw.url
        
        SeSacURLNetwork.callNetwork(url: URL, parameter: nil, method: .post) { response in
            switch response.result {
            case .success(_):
                successData()
            case let .failure(error):
                guard let errorCode = error.responseCode else { return }
                let status = self.checkError(errorCode)
                print("탈퇴 에러 ",status)
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
        AF.request(URL, method: method, parameters: parameter, headers: header, interceptor: checkSesacNetWork()).validate(statusCode: 200...200).responseData(completionHandler: handler)
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
    // 친구 요청하기
    func hobbyRequest(userID: String, successData: @escaping () -> (), failErrror: @escaping (String?) -> ()) {
        let URL = Point.hobbyRequest.url
        let parameter: Parameters = [
          "otheruid": "\(userID)"
        ]
        
        SeSacURLNetwork.callNetwork(url: URL, parameter: parameter, method: .post) { response in
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
    // 친구 수락하기
    func hobbyAccept(userID: String, successData: @escaping () -> (), failErrror: @escaping (String?) -> ()) {
        let URL = Point.hobbyAccept.url
        let parameter: Parameters = [
          "otheruid": "\(userID)"
        ]
        
        SeSacURLNetwork.callNetwork(url: URL, parameter: parameter, method: .post) { response in
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
    // 본인 상태 확인
    func myStatus(successData: @escaping (SeSacStateModel) -> (), failErrror: @escaping (String?) -> ()) {
        let URL = Point.queueState.url
        
        SeSacURLNetwork.callNetwork(url: URL, parameter: nil, method: .get) { response in
            switch response.result {
            case .success:
                guard let data = response.value else { return }
                let decoder = JSONDecoder()
                let json = try? decoder.decode(SeSacStateModel.self, from: data)
                guard let json = json else {return}
                successData(json)
            case let .failure(error):
                guard let errorCode = error.responseCode else { return }
                let status = self.checkError(errorCode)
                failErrror(status)
            }
        }
    }
    // 채팅 보내기
    func sendChat(uid: String, sendMessage: String, successData: @escaping (SendChatModel) -> (), failErrror: @escaping (String?) -> ()) {
        let url = "\(Point.sendChat.url)" + "\(uid)"
        let URL = URL(string: url)!
        
        let header: HTTPHeaders = [
            "idtoken" : UserDefaults.standard.string(forKey: UserDefaultsManager.authIdToken)!,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        let parameter = [
            "chat" : "\(sendMessage)"
        ]
        
        AF.request(URL, method: .post, parameters: parameter, encoding: URLEncoding(arrayEncoding: .noBrackets), headers: header, interceptor: checkSesacNetWork()).validate(statusCode: 200...200).responseData { response in
            switch response.result {
            case .success:
                guard let data = response.value else { return }
                let decoder = JSONDecoder()
                let json = try? decoder.decode(SendChatModel.self, from: data)
                guard let json = json else {return}
                successData(json)
            case let .failure(error):
                guard let errorCode = error.responseCode else { return }
                print(errorCode)
                let status = self.checkError(errorCode)
                failErrror(status)
            }
        }
    }
    // 채팅 가져오기
    func getChat(otherUid: String, successData: @escaping (GetChatModel) -> (), failErrror: @escaping (String?) -> ()) {
        let url = "\(Point.sendChat.url)" + "\(otherUid)?lastchatDate=2022-01-01"
        let URL = URL(string: url)!
        
        let header: HTTPHeaders = [
            "idtoken" : UserDefaults.standard.string(forKey: UserDefaultsManager.authIdToken)!,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        AF.request(URL, method: .get, headers: header).responseDecodable(of: GetChatModel.self) { response in
            switch response.result {
            case .success(let success):
                successData(success)
            case let .failure(error):
                guard let errorCode = error.responseCode else { return }
                print(errorCode)
                let status = self.checkError(errorCode)
                failErrror(status)
            }
        }
    }
    
    
    // 약속 취소
    func cancelApointment(uid: String,successData: @escaping () -> (), failErrror: @escaping (String?) -> ()) {
        let URL = Point.cancelApointment.url
        let paramters = [
            "otheruid" : "\(uid)"
        ]
        SeSacURLNetwork.callNetwork(url: URL, parameter: paramters, method: .post) { response in
            switch response.result {
            case .success:
                successData()
            case let .failure(error):
                guard let errorCode = error.responseCode else { return }
                let status = self.checkError(errorCode)
                failErrror(status)
            }
        }
    }
    
    // * 신고하기 기능
    func reportUser(otherUid: String ,report: [Int], comment: String, successData: @escaping () -> ()) {
        let comment = comment == "신고 사유를 적어주세요\n허위 신고 시 제재를 받을 수 있습니다" ? "" : comment
        let URL = Point.reportUser.url
        let header: HTTPHeaders = [
            "idtoken" : UserDefaults.standard.string(forKey: UserDefaultsManager.authIdToken)!,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let paramters: Parameters? = [
           "otheruid" : "\(otherUid)",
           "reportedReputation" : report,
           "comment" : comment
        ]
        
        AF.request(URL, method: .post, parameters: paramters, encoding: URLEncoding(arrayEncoding: .noBrackets), headers: header, interceptor: checkSesacNetWork()).validate(statusCode: 200...200).responseData { response in
            switch response.result {
            case .success:
                successData()
            case let .failure(error):
                guard let errorCode = error.responseCode else { return }
                print(errorCode)
            }
        }
    }
    // * 리뷰하기 기능
    func reviewUser(otherUid: String ,report: [Int], comment: String, successData: @escaping () -> ()) {
        let comment = comment == "자세한 피드백은 다른 새싹들에게도 도움이 됩니다 (500자 이내 작성)" ? "" : comment
        let url = "\(Point.review.url)" + "\(otherUid)"
        let URL = URL(string: url)!
        
        let header: HTTPHeaders = [
            "idtoken" : UserDefaults.standard.string(forKey: UserDefaultsManager.authIdToken)!,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let paramters: Parameters? = [
           "otheruid" : "\(otherUid)",
           "reputation" : report,
           "comment" : comment
        ]
        
        AF.request(URL, method: .post, parameters: paramters, encoding: URLEncoding(arrayEncoding: .noBrackets), headers: header, interceptor: checkSesacNetWork()).validate(statusCode: 200...200).responseData { response in
            switch response.result {
            case .success:
                successData()
            case let .failure(error):
                guard let errorCode = error.responseCode else { return }
                print(errorCode)
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
            case .success:
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

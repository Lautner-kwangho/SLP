//
//  AuthError.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/25.
//

import Foundation

enum AuthError: Int, Error, CaseIterable {
    case FIRAuthErrorCodeTooManyRequests = 17010
    case invalidVerificationCode = 17044
    case sessionExpired = 17051
    case quotaExceeded = 17052
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .FIRAuthErrorCodeTooManyRequests:
            return "너무 많이 시도하였습니다. 잠시후 다시 시도해주세요"
        case .invalidVerificationCode:
            return "올바르지 않는 코드입니다"
        case .sessionExpired:
            return "인증번호가 만료되어 재전송받기 바랍니다"
        case .quotaExceeded:
            return "일일 할당량이 초과하였습니다 잠시후 다시 시도해주세요"
        @unknown default:
            return "에러 발생, 내용을 확인해주세요"
        }
    }

    static func authCheckError(_ code: Int) -> String {
        guard let authText = AuthError(rawValue: code)?.errorDescription else { return "" }
        return authText
    }
}

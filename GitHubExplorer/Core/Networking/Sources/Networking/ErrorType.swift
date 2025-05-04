//
//  ErrorType.swift
//  Networking
//
//  Created by Duy Thanh on 3/5/25.
//

import Foundation

public enum APIError: Error, LocalizedError, Equatable {
    case unauthorized
    case networkError
    case serverError(statusCode: Int, message: String?)
    case decodingError
    case unknown(String)

    public var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Your session has expired. Please log in again."
        case .networkError:
            return "No network connection. Please check your internet connection."
        case .serverError(_, let message):
            return message ?? "A server error has occurred."
        case .decodingError:
            return "Unable to process the response data."
        case .unknown(let error):
            return error
        }
    }

    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.unauthorized, .unauthorized):
            return true
        case (.networkError, .networkError):
            return true
        case (.decodingError, .decodingError):
            return true
        case let (.serverError(code1, message1), .serverError(code2, message2)):
            return code1 == code2 && message1 == message2
        case let (.unknown(error1), .unknown(error2)):
            return error1 == error2
        default:
            return false
        }
    }
}

extension APIError {
    var isRetriable: Bool {
        switch self {
        case .networkError:
            return true
        case let .serverError(statusCode, _) where statusCode >= 500:
            return true
        default:
            return false
        }
    }
}

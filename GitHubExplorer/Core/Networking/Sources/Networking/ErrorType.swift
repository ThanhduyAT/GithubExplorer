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
    case serverError
    case decodingError
    case unknown(String)

    public var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Your session has expired. Please log in again."
        case .networkError:
            return "No network connection. Please check your internet connection."
        case .serverError:
            return "A server error has occurred."
        case .decodingError:
            return "Unable to process the response data."
        case .unknown(let error):
            return error
        }
    }
}

extension APIError {
    var isRetriable: Bool {
        switch self {
        case .networkError:
            return true
        case .serverError:
            return true
        default:
            return false
        }
    }
}

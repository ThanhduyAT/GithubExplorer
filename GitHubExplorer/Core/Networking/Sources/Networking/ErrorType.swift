//
//  File.swift
//  Networking
//
//  Created by Duy Thanh on 3/5/25.
//

import Foundation

enum APIError: Error, LocalizedError {
    case unauthorized
    case networkError
    case serverError(statusCode: Int, message: String?)
    case decodingError
    case unknown(Error)

    var errorDescription: String? {
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
            return error.localizedDescription
        }
    }
}



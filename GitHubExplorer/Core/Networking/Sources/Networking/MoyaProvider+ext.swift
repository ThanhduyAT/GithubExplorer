// The Swift Programming Language
// https://docs.swift.org/swift-book

import Moya
import Foundation
import Alamofire
import Combine

public class DefaultAlamofireManager: Alamofire.Session, @unchecked Sendable {
    public static let sharedManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.requestCachePolicy = .useProtocolCachePolicy

        // Add URL cache configuration
        let memoryCapacity = 50 * 1024 * 1024 // 50 MB
        let diskCapacity = 100 * 1024 * 1024 // 100 MB
        let diskPath = "github_explorer_cache"
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: diskPath)
        configuration.urlCache = cache
        return Session(configuration: configuration)
    }()
}

extension MoyaProvider {
    public func baseRequest<T: Decodable>(
        _ target: Target,
        type: T.Type
    ) async throws -> T {
        return try await withUnsafeThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let filtered = try response.filterSuccessfulStatusCodes()
                        let decoded = try JSONDecoder().decode(T.self, from: filtered.data)
                        continuation.resume(returning: decoded)
                    } catch let moyaError as MoyaError {
                        let error = self.handleMoyaError(moyaError)
                        continuation.resume(throwing: error)
                    } catch {
                        continuation.resume(throwing: APIError.decodingError)
                    }

                case .failure(let moyaError):
                    let error = self.handleMoyaError(moyaError)
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    public func baseRequestWithRetry<T: Decodable>(
        _ target: Target,
        type: T.Type,
        retries: Int = 2,
        retryDelay: TimeInterval = 1.0
    ) async throws -> T {
        do {
            try _Concurrency.Task.checkCancellation()
            return try await baseRequest(target, type: type)
        } catch let error as APIError where error.isRetriable && retries > 0 {
            try await _Concurrency.Task.sleep(nanoseconds: UInt64(retryDelay * 1_000_000_000))
            // swiftlint:disable:next line_length
            return try await baseRequestWithRetry(target, type: type, retries: retries - 1, retryDelay: retryDelay * 1.5)
        } catch {
            throw error
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
    private func handleMoyaError(_ error: MoyaError) -> APIError {
        if case let .underlying(underlyingError, _) = error {
            if let afError = underlyingError as? AFError,
               case let .sessionTaskFailed(sessionError) = afError,
               let nsError = sessionError as NSError?,
               nsError.domain == NSURLErrorDomain {
                return .networkError
            }
        }
        switch error {
        case 401:
            return .unauthorized
        case 404:
            return .decodingError
        case 500:
            return .networkError
        case 400...499:
            return .serverError
        default:
            return .unknown(error.localizedDescription)
        }
    }
}

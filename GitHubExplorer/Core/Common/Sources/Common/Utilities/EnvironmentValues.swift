//
//  EnvironmentValues.swift
//  Common
//
//  Created by Duy Thanh on 5/5/25.
//

import Foundation

public enum EnvironmentValues {
    public static var environmentType: EnvironmentType {
        guard let raw = rawConfiguration(forKey: "ENV"),
              let type = EnvironmentType(rawValue: raw.uppercased()) else {
            assertionFailure("Invalid or missing ENV key in Info.plist. Defaulting to `.debug`")
            return .debug
        }
        return type
    }

    public static var baseUrl: URL {
        guard let rawHost = rawConfiguration(forKey: "BASE_URL") else {
            fatalError("BASE_URL not found in Info.plist. Please define it under 'BASE_URL' key.")
        }
        guard let url = makeUrl(from: rawHost) else {
            fatalError("Invalid BASE_URL format: \(rawHost)")
        }
        return url
    }

    private static func rawConfiguration(forKey key: String, in bundle: Bundle = .main) -> String? {
        return bundle.object(forInfoDictionaryKey: key) as? String
    }

    private static func makeUrl(from host: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        return urlComponents.url
    }
}

extension EnvironmentValues {
    public enum EnvironmentType: String {
        case debug = "DEBUG"
        case production = "PRODUCTION"
    }
}

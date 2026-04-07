//
//  File.swift
//  Networking
//
//  Created by Thanh Duy on 20/3/26.
//

import Foundation
import Moya

func ~= (pattern: Int, value: MoyaError) -> Bool {
    guard case let .statusCode(response) = value else { return false }
    return response.statusCode == pattern
}

func ~=(pattern: ClosedRange<Int>, value: MoyaError) -> Bool {
    guard case let .statusCode(response) = value else {
        return false
    }
    return pattern.contains(response.statusCode)
}

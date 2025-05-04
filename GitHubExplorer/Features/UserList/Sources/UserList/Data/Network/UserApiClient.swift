//
//  File.swift
//  Networking
//
//  Created by Duy Thanh on 30/4/25.
//

import Foundation

public protocol UserApiClient {
    func getUsers(request: UserListRequest) async throws -> [UserListResponse]
    func getUserDetail(userName: String) async throws -> UserDetailResponse
}

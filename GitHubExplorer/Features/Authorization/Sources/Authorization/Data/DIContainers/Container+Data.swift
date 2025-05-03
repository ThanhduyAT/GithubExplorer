//
//  File.swift
//  Authorization
//
//  Created by Duy Thanh on 2/5/25.
//

import Foundation
import Factory
import Networking
 
extension Container {
    /// Provides the authentication service, responsible for managing session/token storage.
    var authService: Factory<AuthenticationService> {
        self {
            AuthenticationService()
        }
    }

    /// Provides the API client responsible for handling authorization network requests.
    var authApiClient: Factory<AuthorizationApiClient> {
        self {
            AuthorizationApiClientImpl()
        }
    }

    /// Provides the authentication repository, which coordinates between API and service.
    var authRepository: Factory<AuthRepository> {
        self {
            AuthRepositoryImpl(
                apiClient: self.authApiClient(),
                authService: self.authService()
            )
        }
    }
}

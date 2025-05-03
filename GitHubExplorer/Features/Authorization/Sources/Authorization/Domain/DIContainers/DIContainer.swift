//
//  File.swift
//  Authorization
//
//  Created by Duy Thanh on 2/5/25.
//

import Foundation
import Factory

extension Container {    
    var loginUseCase: Factory<LoginUseCase> {
        self {
            LoginUseCaseImpl(authRepository: self.authRepository())
        }
    }
}

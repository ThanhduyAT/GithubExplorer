//
//  LoginFactory.swift
//  Authorization
//
//  Created by Duy Thanh on 2/5/25.
//

import Foundation
import Factory

protocol LoginFactory {
    func makeLoginUseCase() -> LoginUseCase
}

extension Container: LoginFactory {
    func makeLoginUseCase() -> LoginUseCase {
        return loginUseCase.shared()
    }
}

//
//  UseCaseAssembler.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation

protocol UseCaseAssembler {
    func resolve() -> GetUsersUseCase
    func resolve() -> GetUserDetailUseCase
}


extension ServiceAssembler where Self: DefaultAssembler {
    func resolve() -> GetUsersUseCase {
        GetUsersUseCase(
            userRepository: resolve()
        )
    }
    
    func resolve() -> GetUserDetailUseCase {
        GetUserDetailUseCase(
            userRepository: resolve()
        )
    }
}

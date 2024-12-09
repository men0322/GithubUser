//
//  RepositoryAssembler.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation

protocol RepositoryAssembler {
    func resolve() -> UserRepositoryType
}


extension RepositoryAssembler where Self: DefaultAssembler {
    func resolve() -> UserRepositoryType {
        UserRepository(
            userService: resolve(),
            localUserService: resolve()
        )
    }
}

//
//  GetUsersUseCase.swift
//  UserProfile
//
//  Created by Hung Nguyen on 10/12/2024.
//

import Foundation
import Common
import Action

final class GetUsersUseCase: ActionUseCaseType {
    typealias Output = (DataType, [User])
    
    typealias Input = (Int, Int)
    
    let userRepository: UserRepositoryType
    var action: Action<Input, Output>?
    
    init(
        userRepository: UserRepositoryType
    ) {
        self.userRepository = userRepository
        self.action = self.initAction()
    }
   
    private func initAction() -> Action<Input, Output> {
        Action<Input, Output> { [unowned self] params in
            self.userRepository
                .getUsers(
                    perPage: params.0,
                    since: params.1
                )
        }
    }
}


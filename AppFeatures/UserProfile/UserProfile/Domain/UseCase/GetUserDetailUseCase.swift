//
//  GetUserDetailUseCase.swift
//  UserProfile
//
//  Created by Hung Nguyen on 10/12/2024.
//

import Foundation
import Common
import Action

final class GetUserDetailUseCase: ActionUseCaseType {
    typealias Output = User?
    
    typealias Input = String
    
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
                .getUser(
                    login: params
                )
        }
    }
}

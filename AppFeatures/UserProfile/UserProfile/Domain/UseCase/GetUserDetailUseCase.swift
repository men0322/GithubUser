//
//  GetUserDetailUseCase.swift
//  UserProfile
//
//  Created by Hung Nguyen on 10/12/2024.
//

import Foundation
import Common
import Action

/// A use case responsible for retrieving detailed information about a specific user.
final class GetUserDetailUseCase: ActionUseCaseType {
    
    // MARK: - Type Aliases
    /// The output type of the use case, which is an optional `User`.
    typealias Output = User?
    
    /// The input type of the use case, which is a `String` representing the user's login.
    typealias Input = String
    
    // MARK: - Properties
    /// The repository responsible for handling user-related data operations.
    let userRepository: UserRepositoryType
    
    /// The action encapsulating the logic for fetching user details.
    var action: Action<Input, Output>?
    
    // MARK: - Initialization
    /// Initializes the use case with a user repository.
    ///
    /// - Parameter userRepository: An instance of `UserRepositoryType` to handle data operations.
    init(
        userRepository: UserRepositoryType
    ) {
        self.userRepository = userRepository
        self.action = self.initAction()
    }
    
    // MARK: - Private Methods
    /// Initializes the action for retrieving user details.
    ///
    /// - Returns: An `Action` that fetches user details from the repository.
    private func initAction() -> Action<Input, Output> {
        Action<Input, Output> { [unowned self] params in
            self.userRepository
                .getUser(login: params)
        }
    }
}

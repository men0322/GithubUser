//
//  GetUsersUseCase.swift
//  UserProfile
//
//  Created by Hung Nguyen on 10/12/2024.
//

import Foundation
import Common
import Action

/// A use case responsible for retrieving a list of users.
final class GetUsersUseCase: ActionUseCaseType {
    
    // MARK: - Type Aliases
    /// The output type of the use case, which is a tuple containing the data source type (`local` or `remote`) and an array of `User` objects.
    typealias Output = (DataType, [User])
    
    /// The input type of the use case, which is a tuple containing pagination parameters: items per page and the starting point.
    typealias Input = (Int, Int)
    
    // MARK: - Properties
    /// The repository responsible for handling user-related data operations.
    let userRepository: UserRepositoryType
    
    /// The action encapsulating the logic for fetching the list of users.
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
    /// Initializes the action for retrieving a list of users.
    ///
    /// - Returns: An `Action` that fetches a list of users from the repository.
    private func initAction() -> Action<Input, Output> {
        Action<Input, Output> { [unowned self] params in
            self.userRepository
                .getUsers(
                    perPage: params.0,  // Number of users per page
                    since: params.1    // Starting point (e.g., last user ID)
                )
        }
    }
}

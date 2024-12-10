//
//  UserRepositoryType.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation
import RxSwift

/// A protocol defining the operations for fetching user data from both remote and local sources.
protocol UserRepositoryType {
    
    /// Fetches a list of users.
    ///
    /// This method retrieves user data either from the local cache or the remote API, with local data taking precedence.
    ///
    /// - Parameters:
    ///   - perPage: The number of users to fetch per page.
    ///   - since: The starting index for the users to fetch.
    /// - Returns: An `Observable` that emits a tuple containing the data source type (`local` or `remote`) and the list of users.
    func getUsers(
        perPage: Int,
        since: Int
    ) -> Observable<(DataType, [User])>
    
    /// Fetches detailed information about a specific user.
    ///
    /// This method retrieves user details either from the local cache or the remote API, with local data taking precedence.
    ///
    /// - Parameter login: The username or login identifier of the user to fetch.
    /// - Returns: An `Observable` that emits the `User` object or `nil` if not found.
    func getUser(
        login: String
    ) -> Observable<User?>
}


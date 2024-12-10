//
//  UserRepository.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation
import RxSwift
import Common

/// A repository responsible for handling user-related data operations, combining remote and local services.
struct UserRepository: UserRepositoryType {
    
    // MARK: - Dependencies
    /// The service responsible for fetching user data from remote API.
    let userService: UserServiceType
    
    /// The service responsible for managing user data in the local cache.
    let localUserService: UserLocalCacheServiceType
    
    // MARK: - Initialization
    /// Initializes the repository with the required services.
    ///
    /// - Parameters:
    ///   - userService: A service for remote API operations.
    ///   - localUserService: A service for managing local cache.
    init(
        userService: UserServiceType,
        localUserService: UserLocalCacheServiceType
    ) {
        self.userService = userService
        self.localUserService = localUserService
    }
    
    // MARK: - Methods
    /// Fetches a list of users, prioritizing local cache over remote API.
    ///
    /// If the local cache has users, it emits them first. If not, it fetches from the API and saves the result locally.
    ///
    /// - Parameters:
    ///   - perPage: The number of users to fetch per page.
    ///   - since: The starting index for the users to fetch.
    /// - Returns: An observable emitting tuples of data type (`local` or `remote`) and a list of users.
    func getUsers(
        perPage: Int,
        since: Int
    ) -> Observable<(DataType, [User])> {
        // Fetch users from local cache
        let localUsers = localUserService
            .getLocalCacheUsers()
        
        // Fetch users from remote API and save to local cache
        let remoteUsers = userService
            .getUsers(
                perPage: perPage,
                since: since
            )
            .do { (_, users) in
                self.localUserService
                    .saveUsersToLocal(users: users)
            }
        
        // Combine local and remote observables
        return Observable.merge(
            localUsers, remoteUsers
        )
    }
    
    /// Fetches detailed user information, prioritizing local cache over remote API.
    ///
    /// If the local cache has the user's detail, it emits it first. Otherwise, it fetches from the API and saves the result locally.
    ///
    /// - Parameter login: The username or login identifier of the user.
    /// - Returns: An observable emitting a `User` object or `nil`.
    func getUser(
        login: String
    ) -> Observable<User?> {
        // Fetch user detail from local cache
        let localUserDetail = localUserService
            .getLocalCacheUserDetail(login: login)
        
        // Fetch user detail from remote API and save to local cache
        let remoteUserDetail = userService
            .getUser(login: login)
            .do { user in
                guard let user = user else { return }
                self.localUserService
                    .saveUserDetailToLocal(user: user)
            }
        
        // Combine local and remote observables
        return Observable.merge(
            localUserDetail, remoteUserDetail
        )
    }
}

//
//  UserLocalCacheService.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation
import Common
import RxSwift

/// Protocol defining methods for handling user data in local cache.
protocol UserLocalCacheServiceType {
    
    /// Saves an array of users to local storage.
    ///
    /// - Parameter users: The list of users to be saved.
    func saveUsersToLocal(
        users: [User]
    )
    
    /// Saves detailed information about a specific user to local storage.
    ///
    /// - Parameter user: The user object containing details to save.
    func saveUserDetailToLocal(
        user: User
    )
    
    /// Retrieves a list of users from local cache.
    ///
    /// - Returns: An observable emitting a tuple containing the data source type (`local` or `remote`) and a list of users.
    func getLocalCacheUsers() -> Observable<(DataType, [User])>
    
    /// Retrieves detailed information about a specific user from local cache.
    ///
    /// - Parameter login: The login identifier for the user.
    /// - Returns: An observable emitting the user object or `nil` if not found.
    func getLocalCacheUserDetail(
        login: String
    ) -> Observable<User?>
}

/// Keys used for storing user data in `UserDefaults`.
fileprivate struct UserLocalCacheKeys {
    static let usersLocalCacheKey = "usersLocalCacheKey"
    static let userDetailLocalCacheKey = "userLocalCacheKey"
}

/// Implementation of the `UserLocalCacheServiceType` protocol using `UserDefaults`.
struct UserLocalCacheService: UserLocalCacheServiceType {
    
    /// Saves an array of users to local storage.
    ///
    /// The users are encoded into JSON data and stored in `UserDefaults`.
    ///
    /// - Parameter users: The list of users to save.
    func saveUsersToLocal(
        users: [User]
    ) {
        if let data = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(data, forKey: UserLocalCacheKeys.usersLocalCacheKey)
        }
    }
    
    /// Saves detailed information about a specific user to local storage.
    ///
    /// The user's details are encoded into JSON data and stored in `UserDefaults` with a key based on the user's login.
    ///
    /// - Parameter user: The user object to save.
    func saveUserDetailToLocal(
        user: User
    ) {
        if let data = try? JSONEncoder().encode(user),
           let login = user.login {
            UserDefaults.standard.set(data, forKey: UserLocalCacheKeys.userDetailLocalCacheKey + login)
        }
    }
    
    /// Retrieves a list of users from local cache.
    ///
    /// If the data exists and is valid, it decodes the users and emits them as part of an observable.
    /// Otherwise, it returns an empty list.
    ///
    /// - Returns: An observable emitting a tuple containing the data source type (`local`) and the list of users.
    func getLocalCacheUsers() -> Observable<(DataType, [User])> {
        guard let data = UserDefaults.standard.data(forKey: UserLocalCacheKeys.usersLocalCacheKey),
              let users = try? JSONDecoder().decode([User].self, from: data) else {
            return Observable.just((DataType.remote, []))
        }
        
        return .just((DataType.local, users))
    }
    
    /// Retrieves detailed information about a specific user from local cache.
    ///
    /// If the data exists and is valid, it decodes the user's details and emits them as part of an observable.
    /// Otherwise, it returns `nil`.
    ///
    /// - Parameter login: The login identifier for the user.
    /// - Returns: An observable emitting the user object or `nil` if not found.
    func getLocalCacheUserDetail(
        login: String
    ) -> Observable<User?> {
        guard let data = UserDefaults.standard.data(forKey: UserLocalCacheKeys.userDetailLocalCacheKey + login),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return Observable.just(nil)
        }
        
        return .just(user)
    }
}

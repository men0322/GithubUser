//
//  UserService.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation
import RxSwift
import RxCocoa
import ObjectMapper

// Protocol defining the UserServiceType contract
// This ensures any conforming type implements methods to fetch multiple users
// and fetch a specific user asynchronously using RxSwift Observables.
protocol UserServiceType {
    /// Fetches a list of users.
        ///
        /// - Parameters:
        ///   - perPage: The number of users to fetch per request.
        ///   - since: The ID or offset to start fetching users from.
        /// - Returns: An observable sequence of an array of User objects.
    func getUsers(
        perPage: Int, 
        since: Int
    ) -> Observable<[User]>
    
    /// Fetches a single user's details by their login username.
        ///
        /// - Parameter login: The login username of the user to fetch.
        /// - Returns: An observable sequence of an optional User object.
        ///            Returns `nil` if the user is not found.
    func getUser(
        login: String
    ) -> Observable<User?>
}
 
// Implementation of the UserServiceType protocol.
// This struct provides functionality to fetch multiple users or a single user's data asynchronously,
// leveraging RxSwift for reactive programming.
struct UserService: UserServiceType {
    
    /// The scheduler on which the results of the network call will be observed.
    /// Typically, this will be set to MainScheduler for UI updates.
    let resultScheduler: SchedulerType
    
    /// Initializes the UserService with a specified result scheduler.
    ///
    /// - Parameter resultScheduler: The RxSwift scheduler to observe results on.
    ///   Defaults to MainScheduler.instance, ensuring UI updates occur on the main thread.
    init(
        resultScheduler: SchedulerType = MainScheduler.instance
    ) {
        self.resultScheduler = resultScheduler
    }
    
    func getUsers(
        perPage: Int,
        since: Int
    ) -> Observable<[User]> {
        UserTargets
            .FetchUsersTarget(
                perPage: perPage,
                since: since
            )
            .execute()
            .observe(on: resultScheduler)
    }
    
    func getUser(
        login: String
    ) -> Observable<User?> {
        UserTargets
            .FetchUserTarget(
                login: login
            )
            .execute()
            .observe(on: resultScheduler)
    }
}

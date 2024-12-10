//
//  MockUserRepository.swift
//  GitHubUserTests
//
//  Created by Hung Nguyen on 10/12/2024.
//

import Foundation
import RxCocoa
import RxSwift

@testable import UserProfile

final class MockUserRepository: UserRepositoryType {

    var invokedGetUsers = false
    var invokedGetUsersCount = 0
    var invokedGetUsersParameters: (perPage: Int, since: Int)?
    var invokedGetUsersParametersList = [(perPage: Int, since: Int)]()
    var stubbedGetUsersResult: Observable<(DataType, [User])>!

    func getUsers(
        perPage: Int,
        since: Int
    ) -> Observable<(DataType, [User])> {
        invokedGetUsers = true
        invokedGetUsersCount += 1
        invokedGetUsersParameters = (perPage, since)
        invokedGetUsersParametersList.append((perPage, since))
        return stubbedGetUsersResult
    }

    var invokedGetUser = false
    var invokedGetUserCount = 0
    var invokedGetUserParameters: (login: String, Void)?
    var invokedGetUserParametersList = [(login: String, Void)]()
    var stubbedGetUserResult: Observable<User?>!

    func getUser(
        login: String
    ) -> Observable<User?> {
        invokedGetUser = true
        invokedGetUserCount += 1
        invokedGetUserParameters = (login, ())
        invokedGetUserParametersList.append((login, ()))
        return stubbedGetUserResult
    }
}

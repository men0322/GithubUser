//
//  MockUsersRouter.swift
//  GitHubUserTests
//
//  Created by Hung Nguyen on 10/12/2024.
//

import Foundation
import RxSwift
import RxCocoa

@testable import UserProfile

final class MockUsersRouter: UsersViewModelRouting {

    var invokedOpenUserDetail = false
    var invokedOpenUserDetailCount = 0
    var invokedOpenUserDetailParameters: (login: String, Void)?
    var invokedOpenUserDetailParametersList = [(login: String, Void)]()

    func openUserDetail(
        login: String
    ) {
        invokedOpenUserDetail = true
        invokedOpenUserDetailCount += 1
        invokedOpenUserDetailParameters = (login, ())
        invokedOpenUserDetailParametersList.append((login, ()))
    }
}


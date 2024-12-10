//
//  MockUsersViewInput.swift
//  GitHubUserTests
//
//  Created by Hung Nguyen on 10/12/2024.
//

import Foundation
import RxSwift
import RxCocoa

@testable import UserProfile

final class MockUsersViewInput: UsersViewInput {

    var invokedLoadMoreTriggerGetter = false
    var invokedLoadMoreTriggerGetterCount = 0
    var stubbedLoadMoreTrigger: PublishRelay<Void>!

    var loadMoreTrigger: PublishRelay<Void> {
        invokedLoadMoreTriggerGetter = true
        invokedLoadMoreTriggerGetterCount += 1
        return stubbedLoadMoreTrigger
    }

    var invokedRefreshTriggerGetter = false
    var invokedRefreshTriggerGetterCount = 0
    var stubbedRefreshTrigger: PublishRelay<Void>!

    var refreshTrigger: PublishRelay<Void> {
        invokedRefreshTriggerGetter = true
        invokedRefreshTriggerGetterCount += 1
        return stubbedRefreshTrigger
    }

    var invokedOpenUserDetailTriggerGetter = false
    var invokedOpenUserDetailTriggerGetterCount = 0
    var stubbedOpenUserDetailTrigger: PublishRelay<String>!

    var openUserDetailTrigger: PublishRelay<String> {
        invokedOpenUserDetailTriggerGetter = true
        invokedOpenUserDetailTriggerGetterCount += 1
        return stubbedOpenUserDetailTrigger
    }
}

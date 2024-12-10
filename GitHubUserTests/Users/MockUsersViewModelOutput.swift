//
//  MockUsersViewModelOutput.swift
//  GitHubUserTests
//
//  Created by Hung Nguyen on 10/12/2024.
//

import Foundation
import RxCocoa
import RxSwift

@testable import UserProfile

final class MockUsersViewModelOutput: UsersViewModelOutput {

    var invokedViewInputSetter = false
    var invokedViewInputSetterCount = 0
    var invokedViewInput: UsersViewInput?
    var invokedViewInputList = [UsersViewInput?]()
    var invokedViewInputGetter = false
    var invokedViewInputGetterCount = 0
    var stubbedViewInput: UsersViewInput!

    var viewInput: UsersViewInput? {
        set {
            invokedViewInputSetter = true
            invokedViewInputSetterCount += 1
            invokedViewInput = newValue
            invokedViewInputList.append(newValue)
        }
        get {
            invokedViewInputGetter = true
            invokedViewInputGetterCount += 1
            return stubbedViewInput
        }
    }

    var invokedCellModelsGetter = false
    var invokedCellModelsGetterCount = 0
    var stubbedCellModels: BehaviorRelay<[UserInfoViewCellModel]>!

    var cellModels: BehaviorRelay<[UserInfoViewCellModel]> {
        invokedCellModelsGetter = true
        invokedCellModelsGetterCount += 1
        return stubbedCellModels
    }

    var invokedIsLoadingGetter = false
    var invokedIsLoadingGetterCount = 0
    var stubbedIsLoading: BehaviorRelay<Bool>!

    var isLoading: BehaviorRelay<Bool> {
        invokedIsLoadingGetter = true
        invokedIsLoadingGetterCount += 1
        return stubbedIsLoading
    }
}

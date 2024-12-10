//
//  MockUserDetailOutput.swift
//  GitHubUserTests
//
//  Created by Hung Nguyen on 10/12/2024.
//

import Foundation
import RxCocoa
import RxSwift

@testable import UserProfile

final class MockUserDetailOutput: UserDetailViewModelOutput {

    var invokedViewInputSetter = false
    var invokedViewInputSetterCount = 0
    var invokedViewInput: UserDetailViewInput?
    var invokedViewInputList = [UserDetailViewInput?]()
    var invokedViewInputGetter = false
    var invokedViewInputGetterCount = 0
    var stubbedViewInput: UserDetailViewInput!

    var viewInput: UserDetailViewInput? {
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

    var invokedCellTypesGetter = false
    var invokedCellTypesGetterCount = 0
    var stubbedCellTypes: BehaviorRelay<[UserDetailCellType]>!

    var cellTypes: BehaviorRelay<[UserDetailCellType]> {
        invokedCellTypesGetter = true
        invokedCellTypesGetterCount += 1
        return stubbedCellTypes
    }
}

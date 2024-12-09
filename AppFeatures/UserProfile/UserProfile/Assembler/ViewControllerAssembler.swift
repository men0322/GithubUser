//
//  ViewControllerAssembler.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation
import RxSwift

protocol ViewControllerAssembler {
    func resolve() -> UsersViewController?
}


extension ViewControllerAssembler where Self: DefaultAssembler {
    func resolve() -> UsersViewController? {
        let viewController = R.storyboard.users.usersViewController()
        viewController?.viewModel = resolve()
        return viewController
    }
}

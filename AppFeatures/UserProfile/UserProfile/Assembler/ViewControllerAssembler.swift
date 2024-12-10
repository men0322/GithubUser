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
    func resolve(
        login: String
    ) -> UserDetailViewController?
}


extension ViewControllerAssembler where Self: DefaultAssembler {
    func resolve() -> UsersViewController? {
        let viewController = R.storyboard.users.usersViewController()
        viewController?.viewModel = resolve()
        return viewController
    }
    
    func resolve(
        login: String
    ) -> UserDetailViewController? {
        let viewController = R.storyboard.userDetail.userDetailViewController()
        viewController?.viewModel = resolve(login: login)
        return viewController
    }
}

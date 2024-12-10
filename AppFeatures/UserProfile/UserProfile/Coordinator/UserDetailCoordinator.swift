//
//  UserDetailCoordinator.swift
//  UserProfile
//
//  Created by Hung Nguyen on 10/12/2024.
//

import UIKit
import Common

class UserDetailCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    let login: String
    init(
        navigationController: UINavigationController,
        login: String
    ) {
        self.navigationController = navigationController
        self.login = login
    }

    func start() {
        if let userDetailViewController: UserDetailViewController = Environment.current.defaultAssembler.resolve(login: login) {
            navigationController.pushViewController(userDetailViewController, animated: true)
        }
    }
}

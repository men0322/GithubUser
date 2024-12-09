//
//  AppCoordinator.swift
//  GitHubUser
//
//  Created by Hung Nguyen on 09/12/2024.
//

import UIKit
import Common
import UserProfile

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showUsersView()
    }

    private func showUsersView() {
        let usersCoordinator = UserProfileCoordinator(
            navigationController: navigationController,
            parentCoordinator: self
        )
        addChildCoordinator(usersCoordinator)
        usersCoordinator.start()
    }
}

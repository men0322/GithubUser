//
//  UserProfileCoordinator.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation
import UIKit
import Common

public final class UsersCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public weak var parentCoordinator: Coordinator?
    
    public init(navigationController: UINavigationController, parentCoordinator: Coordinator?) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        super.init()
        navigationController.delegate = self
    }
    
    public func start() {
        if let usersViewController: UsersViewController = Environment.current.defaultAssembler.resolve() {
            usersViewController.viewModel?.router = self
            navigationController.pushViewController(usersViewController, animated: true)
        }
        
    }
    
    private func showUserDetailScreen(login: String) {
        let userDetailCoordinator = UserDetailCoordinator(
            navigationController: navigationController, 
            login: login
        )
        addChildCoordinator(userDetailCoordinator)
        userDetailCoordinator.start()
    }
    
    // Handle swipe-back and remove child coordinators
    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        // Check if the previous view controller was popped
        if let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
           !navigationController.viewControllers.contains(fromViewController) {
            //If the view controller was a UserDetailViewController, clean up
            if fromViewController is UsersViewController {
                parentCoordinator?.removeChildCoordinator(self)
            }
        }
    }
}

extension UsersCoordinator: UsersViewModelRouting{
    func openUserDetail(login: String) {
        showUserDetailScreen(login: login)
    }
}

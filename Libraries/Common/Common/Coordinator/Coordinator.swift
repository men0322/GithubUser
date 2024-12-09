//
//  Coordinator.swift
//  Common
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation
import UIKit

public protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
}

public extension Coordinator {
    /// Adds a child coordinator to the current coordinator.
    func addChildCoordinator(_ child: Coordinator) {
        childCoordinators.append(child)
    }

    /// Removes a specific child coordinator from the current coordinator.
    func removeChildCoordinator(_ child: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== child }
    }
}

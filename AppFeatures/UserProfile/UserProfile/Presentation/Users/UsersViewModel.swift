//
//  UsersViewModel.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation
import RxSwift
import RxCocoa
import Common

// MARK: - ViewModelType
/// Protocol defining the ViewModel's responsibilities.
protocol UsersViewModelType: ViewModelType {
    /// The output to communicate data changes to the View.
    var viewModelOutput: UsersViewModelOutput? { get set }
    
    /// The router to handle navigation or routing events.
    var router: UsersViewModelRouting? { get set }
}

// MARK: - ViewModelOutput
/// Protocol defining the output properties for the ViewModel.
protocol UsersViewModelOutput: AnyObject {
    /// The input interface for the View.
    var viewInput: UsersViewInput? { get set }
    
    /// Relay containing the cell models for displaying users.
    var cellModels: BehaviorRelay<[UserInfoViewCellModel]> { get }
    
    /// Relay indicating the loading state of the ViewModel.
    var isLoading: BehaviorRelay<Bool> { get }
}

// MARK: - Routing
/// Protocol defining navigation-related methods.
protocol UsersViewModelRouting: AnyObject {
    /// Opens the user detail screen for a given user.
    ///
    /// - Parameter login: The login/username of the user.
    func openUserDetail(
        login: String
    )
}

// MARK: - ViewModel
/// ViewModel for the Users screen, handling logic, data fetching, and navigation.
final class UsersViewModel: UsersViewModelType, UsersViewInput {

    // MARK: - Properties
    weak var viewModelOutput: UsersViewModelOutput?
    weak var router: UsersViewModelRouting?
    
    /// Trigger to load more users when scrolled to the bottom.
    let loadMoreTrigger = PublishRelay<Void>()
    
    /// Trigger to refresh the list of users.
    let refreshTrigger = PublishRelay<Void>()
    
    /// Trigger to open user detail for a selected user.
    let openUserDetailTrigger = PublishRelay<String>()
    
    /// Dispose bag for managing subscriptions.
    let disposeBag = DisposeBag()
    
    /// Number of users to load per page.
    private let perPage: Int = 20
    
    /// Tracks the last user ID for pagination.
    private var since: Int = 0
    
    /// Use case for fetching users.
    private let getUsersUseCase: GetUsersUseCase
    
    // MARK: - Initializer
    /// Initializes the ViewModel with the required use case.
    ///
    /// - Parameter getUsersUseCase: Use case for fetching users.
    init(
        getUsersUseCase: GetUsersUseCase
    ) {
        self.getUsersUseCase = getUsersUseCase
    }
    
    // MARK: - Lifecycle
    /// Called when the ViewModel becomes active to start setup processes.
    func didBecomeActive() {
        viewModelOutput?.viewInput = self
        configureInput()
        configureOutPut()
    }
}

// MARK: - Configuration
extension UsersViewModel {
    /// Configures the input triggers and their corresponding actions.
    private func configureInput() {
        // Handle load more trigger.
        loadMoreTrigger
            .subscribeNext { [weak self] in
                guard let self else { return }
                self.loadUsers()
            }
            .disposed(by: disposeBag)
        
        // Handle refresh trigger.
        refreshTrigger
            .subscribeNext { [weak self] in
                guard let self else { return }
                self.since = 0
                self.loadUsers()
            }
            .disposed(by: disposeBag)
        
        // Handle opening user detail trigger.
        openUserDetailTrigger
            .subscribeNext { [weak self] login in
                guard let self else { return }
                self.router?.openUserDetail(login: login)
            }
            .disposed(by: disposeBag)
    }
    
    /// Configures the output bindings for the ViewModel.
    private func configureOutPut() {
        guard let output = viewModelOutput else { return }
        
        // Bind fetched user data to cell models.
        getUsersUseCase
            .action?
            .elements
            .doOnNext { [weak self] arg in
                // Update `since` value if the data is from the remote source.
                let (dataType, users) = arg
                guard let self,
                      dataType == .remote else { return }
                self.since = users.last?.id ?? 0
            }
            .map {
                // Map users to cell models.
                $0.1.compactMap {
                    UserInfoViewCellModel(user: $0)
                }
            }
            .map { [weak self] newCellModels in
                guard let self else { return newCellModels }
                // If refreshing, replace the current list.
                if self.since == 0 {
                    return newCellModels
                }
                // Otherwise, append new users to the existing list.
                let currentCellModels = self.viewModelOutput?.cellModels.value ?? []
                return currentCellModels + newCellModels
            }
            .bind(to: output.cellModels)
            .disposed(by: disposeBag)
        
        // Start loading users.
        loadUsers()
        
        // Bind loading state to the output's `isLoading` relay.
        getUsersUseCase
            .action?
            .executing
            .bind(to: output.isLoading)
            .disposed(by: disposeBag)
    }
    
    /// Loads the users based on the current pagination state.
    private func loadUsers() {
        getUsersUseCase
            .action?
            .execute(
                (perPage, since)
            )
    }
}

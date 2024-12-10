//
//  UserDetailViewModel.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation
import RxSwift
import RxCocoa
import Common

// MARK: - ViewModelType
/// Protocol defining the ViewModel's type and its responsibilities.
protocol UserDetailViewModelType: ViewModelType {
    /// ViewModel's output to communicate data changes to the View.
    var viewModelOutput: UserDetailViewModelOutput? { get set }
    
    /// Router to handle navigation or routing events.
    var router: UserDetailViewModelRouting? { get set }
}

// MARK: - ViewModelOutput
/// Protocol for ViewModel's output, used to pass data to the view layer.
protocol UserDetailViewModelOutput: AnyObject {
    /// View's input reference to handle updates.
    var viewInput: UserDetailViewInput? { get set }
    
    /// Relay that contains the list of cell types for the table or collection view.
    var cellTypes: BehaviorRelay<[UserDetailCellType]> { get }
}

// MARK: - Routing
/// Protocol defining routing responsibilities for navigation.
protocol UserDetailViewModelRouting: AnyObject { }

// MARK: - Cell Types
/// Enum defining the different cell types used in the User Detail screen.
enum UserDetailCellType {
    case info(UserInfoViewCellModel)
    case follow(UserFollowCellModel)
    case blog(UserBlogCellModel)
}

// MARK: - UserDetailViewModel
/// The ViewModel for the User Detail screen, managing inputs, outputs, and business logic.
final class UserDetailViewModel: UserDetailViewModelType, UserDetailViewInput {

    // MARK: - Properties
    /// ViewModel's output to pass data to the View.
    weak var viewModelOutput: UserDetailViewModelOutput?
    
    /// Router to manage navigation actions.
    weak var router: UserDetailViewModelRouting?
    
    /// Dispose bag for managing subscriptions.
    let disposeBag = DisposeBag()
    
    /// Use case for fetching user details.
    let getUserDetailUseCase: GetUserDetailUseCase
    
    /// The login/username of the user to fetch details for.
    let login: String

    // MARK: - Initializer
    /// Initializes the ViewModel with necessary dependencies.
    ///
    /// - Parameters:
    ///   - getUserDetailUseCase: Use case for fetching user details.
    ///   - login: The login/username of the user.
    init(
        getUserDetailUseCase: GetUserDetailUseCase,
        login: String
    ) {
        self.getUserDetailUseCase = getUserDetailUseCase
        self.login = login
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
extension UserDetailViewModel {
    /// Configures input handling (e.g., user actions).
    private func configureInput() {
        // Add any input bindings here if needed in the future.
    }
    
    /// Configures the output, mapping the fetched user data to UI cell types.
    private func configureOutPut() {
        guard let output = viewModelOutput else { return }
        
        // Map user details fetched from the use case to corresponding cell models.
        getUserDetailUseCase
            .action?
            .elements
            .map { user in
                guard let user = user else { return [] }
                
                // Define different cell types.
                let cellInfo = UserDetailCellType.info(UserInfoViewCellModel(isUserDetail: true, user: user))
                let cellFollow = UserDetailCellType.follow(UserFollowCellModel(user: user))
                let cellBlog = UserDetailCellType.blog(UserBlogCellModel(user: user))
                
                return [cellInfo, cellFollow, cellBlog]
            }
            // Bind the result to the cellTypes relay for the View to observe.
            .bind(to: output.cellTypes)
            .disposed(by: disposeBag)
        
        // Execute the use case to fetch user details.
        getUserDetailUseCase.action?.execute(login)
    }
}

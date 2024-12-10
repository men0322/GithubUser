//
//
//  UserDetailViewModel.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//
//

import Foundation
import RxSwift
import RxCocoa
import Common

// MARK: - ViewModelType
protocol UserDetailViewModelType: ViewModelType {
    var viewModelOutput: UserDetailViewModelOutput? { get set }
    var router: UserDetailViewModelRouting? { get set }
}

// MARK: - ViewModelOutput
protocol UserDetailViewModelOutput: AnyObject {
    var viewInput: UserDetailViewInput? { get set }
    var cellTypes: BehaviorRelay<[UserDetailCellType]> { get }
}

// MARK: - Routing
protocol UserDetailViewModelRouting: AnyObject {
    
}

enum UserDetailCellType {
    case info(UserInfoViewCellModel)
    case follow(UserFollowCellModel)
    case blog(UserBlogCellModel)
}

final class UserDetailViewModel: UserDetailViewModelType, UserDetailViewInput {

    weak var viewModelOutput: UserDetailViewModelOutput?
    weak var router: UserDetailViewModelRouting?
    
    let disposeBag = DisposeBag()
    
    let getUserDetailUseCase: GetUserDetailUseCase
    let login: String
    init(
        getUserDetailUseCase: GetUserDetailUseCase,
        login: String
    ) {
        self.getUserDetailUseCase = getUserDetailUseCase
        self.login = login
    }
    
    func didBecomeActive() {
        viewModelOutput?.viewInput = self
        configureInput()
        configureOutPut()
    }
}

// MARK: - Configiure
extension UserDetailViewModel {
    private func configureInput() {
        
    }
    
    private func configureOutPut() {
        guard let output = viewModelOutput else { return }
        
        getUserDetailUseCase
            .action?
            .elements
            .map { user in
                guard let user = user else { return [] }
                let cellInfo = UserDetailCellType.info(UserInfoViewCellModel(isUserDetail: true, user: user))
                let cellFollow = UserDetailCellType.follow(UserFollowCellModel(user: user))
                let cellBlog = UserDetailCellType.blog(UserBlogCellModel(user: user))
                return [cellInfo, cellFollow, cellBlog]
            }
            .bind(to: output.cellTypes)
            .disposed(by: disposeBag)
        
        getUserDetailUseCase.action?.execute(login)
    
    }
}

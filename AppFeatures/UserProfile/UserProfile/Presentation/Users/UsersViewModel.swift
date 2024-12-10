//
//  
//  UsersViewModel.swift
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
protocol UsersViewModelType: ViewModelType {
    var viewModelOutput: UsersViewModelOutput? { get set }
    var router: UsersViewModelRouting? { get set }
}

// MARK: - ViewModelOutput
protocol UsersViewModelOutput: AnyObject {
    var viewInput: UsersViewInput? { get set }
    var cellModels: BehaviorRelay<[UserInfoViewCellModel]> { get }
    var isLoading: BehaviorRelay<Bool> { get }
}

// MARK: - Routing
protocol UsersViewModelRouting: AnyObject {
    func openUserDetail(
        login: String
    )
}

final class UsersViewModel: UsersViewModelType, UsersViewInput {

    weak var viewModelOutput: UsersViewModelOutput?
    weak var router: UsersViewModelRouting?
    
    let loadMoreTrigger = PublishRelay<Void>()
    let refreshTrigger = PublishRelay<Void>()
    let openUserDetailTrigger = PublishRelay<String>()
    
    let disposeBag = DisposeBag()
    
    private let perPage: Int = 20
    private var since: Int = 0
    
    private let getUsersUseCase: GetUsersUseCase
    init(
        getUsersUseCase: GetUsersUseCase
    ) {
        self.getUsersUseCase = getUsersUseCase
    }
    
    func didBecomeActive() {
        viewModelOutput?.viewInput = self
        configureInput()
        configureOutPut()
    }
}

// MARK: - Configiure
extension UsersViewModel {
    private func configureInput() {
        loadMoreTrigger
            .subscribeNext { [weak self] in
                guard let self else { return }
                self.loadUsers()
            }
            .disposed(by: disposeBag)
        
        refreshTrigger
            .subscribeNext { [weak self] in
                guard let self else { return }
                self.since = 0
                self.loadUsers()
            }
            .disposed(by: disposeBag)
        
        openUserDetailTrigger
            .subscribeNext { [weak self] login in
                guard let self else { return }
                self.router?.openUserDetail(login: login)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureOutPut() {
        guard let output = viewModelOutput else { return }
        
        getUsersUseCase
            .action?
            .elements
            .doOnNext { [weak self] arg in
                /// Update since if respont type is remote
                let (dataType, users) = arg
                guard let self ,
                dataType == .remote else { return }
                self.since = users.last?.id ?? 0
            }
            .map {
                $0.1.compactMap {
                    UserInfoViewCellModel(user: $0)
                }
            }
            .map { [weak self] newCellModes in
                guard let self else { return newCellModes }
                if self.since == 0 {
                    return newCellModes
                }
                let currentCellModels = self.viewModelOutput?.cellModels.value ?? []
                return currentCellModels + newCellModes
                
            }
            .bind(to: output.cellModels)
            .disposed(by: disposeBag)
        
        loadUsers()
        
        getUsersUseCase
            .action?
            .executing
            .bind(to: output.isLoading)
            .disposed(by: disposeBag)
    }
    
    private func loadUsers() {
        getUsersUseCase
            .action?
            .execute(
                (perPage, since)
            )
    }
}

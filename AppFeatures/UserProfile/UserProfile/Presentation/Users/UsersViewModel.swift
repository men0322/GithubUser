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

// MARK: - Presentable
protocol UsersViewModelOutput: AnyObject {
    var viewInput: UsersViewInput? { get set }
}

// MARK: - Routing
protocol UsersViewModelRouting: AnyObject {
    
}

final class UsersViewModel: UsersViewModelType, UsersViewInput {

    weak var viewModelOutput: UsersViewModelOutput?
    weak var router: UsersViewModelRouting?
    
    let disposeBag = DisposeBag()
    
    init() {
        
    }
    
    func didBecomeActive() {
        viewModelOutput?.viewInput = self
        configureListener()
        configurePresenter()
    }
}

// MARK: - Configiure
extension UsersViewModel {
    private func configureListener() {
        
    }
    
    private func configurePresenter() {
        
    }
}

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

// MARK: - Presentable
protocol UserDetailViewModelOutput: AnyObject {
    var viewInput: UserDetailViewInput? { get set }
}

// MARK: - Routing
protocol UserDetailViewModelRouting: AnyObject {
    
}

final class UserDetailViewModel: UserDetailViewModelType, UserDetailViewInput {

    weak var viewModelOutput: UserDetailViewModelOutput?
    weak var router: UserDetailViewModelRouting?
    
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
extension UserDetailViewModel {
    private func configureListener() {
        
    }
    
    private func configurePresenter() {
        
    }
}

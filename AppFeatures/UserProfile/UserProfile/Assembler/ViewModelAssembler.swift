//
//  ViewModelAssembler.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation

protocol ViewModelAssembler {
    func resolve() -> UsersViewModelType
    func resolve(
        login: String
    ) -> UserDetailViewModelType
}


extension ViewModelAssembler where Self: DefaultAssembler {
    func resolve() -> UsersViewModelType {
        UsersViewModel(getUsersUseCase: resolve())
    }
    
    func resolve(login: String) -> UserDetailViewModelType {
        UserDetailViewModel(
            getUserDetailUseCase: resolve(), 
            login: login
        )
    }
}

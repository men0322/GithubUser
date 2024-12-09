//
//  ViewModelAssembler.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation

protocol ViewModelAssembler {
    func resolve() -> UsersViewModelType
}


extension ViewModelAssembler where Self: DefaultAssembler {
    func resolve() -> UsersViewModelType {
        UsersViewModel()
    }
}

//
//  ServiceAssembler.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation

protocol ServiceAssembler {
    func resolve() -> UserServiceType
    func resolve() -> UserLocalCacheServiceType
}


extension ServiceAssembler where Self: DefaultAssembler {
    func resolve() -> UserServiceType {
        UserService()
    }
    
    func resolve() -> UserLocalCacheServiceType {
        UserLocalCacheService()
    }
}

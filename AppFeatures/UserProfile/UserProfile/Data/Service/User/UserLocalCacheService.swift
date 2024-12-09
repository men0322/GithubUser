//
//  UserLocalCacheService.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation
import Common
import RxSwift

protocol UserLocalCacheServiceType {
    func saveUsersToLocal(
        users: [User]
    )
    
    func saveUserDetailToLocal(
        user: User
    )
    
    func getLocalCacheUsers() -> Observable<[User]>
    
    func getLocalCacheUserDetail(
        login: String
    ) -> Observable<User?>
}

fileprivate struct UserLocalCacheKeys {
    static let usersLocalCacheKey = "usersLocalCacheKey"
    static let userDetailLocalCacheKey = "userLocalCacheKey"
}

struct UserLocalCacheService: UserLocalCacheServiceType {
    func saveUsersToLocal(
        users: [User]
    ) {
        if let data = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(data, forKey: UserLocalCacheKeys.usersLocalCacheKey)
        }
    }
    
    func saveUserDetailToLocal(
        user: User
    ) {
        if let data = try? JSONEncoder().encode(user),
            let login = user.login {
            UserDefaults.standard.set(data, forKey: UserLocalCacheKeys.userDetailLocalCacheKey + login)
        }
    }
    
    func getLocalCacheUsers() -> Observable<[User]> {
        guard let data = UserDefaults.standard.data(forKey: UserLocalCacheKeys.usersLocalCacheKey),
              let users = try? JSONDecoder().decode([User].self, from: data) else {
            return Observable.just([])
        }
        
        return .just(users)
    }
    
    func getLocalCacheUserDetail(
        login: String
    ) -> Observable<User?> {
        
        guard let data = UserDefaults.standard.data(forKey: UserLocalCacheKeys.usersLocalCacheKey + login),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return Observable.just(nil)
        }
        
        return .just(user)
    }
}

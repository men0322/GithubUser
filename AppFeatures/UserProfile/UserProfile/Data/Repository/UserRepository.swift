//
//  UserRepository.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation
import RxSwift
import Common

struct UserRepository: UserRepositoryType {
    let userService: UserServiceType
    let localUserService: UserLocalCacheServiceType
    
    init(
        userService: UserServiceType,
        localUserService: UserLocalCacheServiceType
    ) {
        self.userService = userService
        self.localUserService = localUserService
    }
    
    func getUsers(
        perPage: Int,
        since: Int
    ) -> Observable<[User]> {
        let localUsers = localUserService
            .getLocalCacheUsers()
        
        let remoteUsers = userService
            .getUsers(
                perPage: perPage,
                since: since
            )
            .do { users in
                self.localUserService
                    .saveUsersToLocal(
                        users: users
                    )
            }
        
        return Observable.merge(
            localUsers, remoteUsers
        )
    }
    
    func getUser(
        login: String
    ) -> Observable<User?> {
        let localUserDetail = localUserService
            .getLocalCacheUserDetail(login: login)
        
        let remoteUserDetail = userService
            .getUser(
                login: login
            )
            .do { user in
                guard let user = user else { return }
                self.localUserService
                    .saveUserDetailToLocal(
                        user: user
                    )
            }
        
        return Observable.merge(
            localUserDetail, remoteUserDetail
        )
    }
}

//
//  UserRepositoryType.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation
import RxSwift

protocol UserRepositoryType {
    func getUsers(
        perPage: Int,
        since: Int
    ) -> Observable<(DataType, [User])>
    
    func getUser(
        login: String
    ) -> Observable<User?>
}

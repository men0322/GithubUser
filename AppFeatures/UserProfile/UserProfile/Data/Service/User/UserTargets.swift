//
//  UserTargets.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation
import ObjectMapper
import Alamofire
import ApiClient

/// Enum containing API targets related to user data.
/// Each target defines the endpoint, HTTP method, and other details required for making the network request.
///
enum UserTargets {
    /// API target for fetching a list of users.
    struct FetchUsersTarget: Requestable {
        typealias Output = [User]
  
        let perPage: Int
        let since: Int
        
        var httpMethod: HTTPMethod { return .get }
        
        var endpoint: String {
            return "users"
        }
        
        var params: Parameters {
            return [
                "per_page": perPage,
                "since": since
            ]
        }
        
        func decode(data: Any) -> Output {
            return Mapper<User>().mapArray(JSONObject: data) ?? []
        }
    }
    
    /// API target for fetching details of a specific user by login.
    struct FetchUserTarget: Requestable {
        typealias Output = User?
  
        let login: String
        
        var httpMethod: HTTPMethod { return .get }
        var endpoint: String {
            return "users/\(login)"
        }
        
        var params: Parameters {
            return [:]
        }
        
        func decode(data: Any) -> Output {
            return Mapper<User>().map(JSONObject: data)
        }
    }
}

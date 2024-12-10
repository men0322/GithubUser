//
//  User+Data.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation
import ObjectMapper

/// An extension to the `User` model to add data mapping and derived properties.
extension User {
    
    /// Maps JSON keys to the properties of the `User` model using ObjectMapper.
    ///
    /// This method is used to parse data from a JSON response and assign the corresponding values
    /// to the properties of the `User` object.
    ///
    /// - Parameter map: A `Map` object provided by ObjectMapper to handle key-value mapping.
    public mutating func mapping(map: Map) {
        id <- map["id"]
        login <- map["login"]
        avatarUrlString <- map["avatar_url"]
        htmlUrlString <- map["html_url"]
        followers <- map["followers"]
        following <- map["following"]
        location <- map["location"]
    }
    
    /// A computed property that converts the `avatarUrlString` to a `URL` object.
    ///
    /// - Returns: A `URL` object if the `avatarUrlString` is valid; otherwise, `nil`.
    var avatarUrl: URL? {
        guard let avatarUrlString = avatarUrlString else { return nil }
        return URL(string: avatarUrlString)
    }
    
    /// A computed property that converts the `htmlUrlString` to a `URL` object.
    ///
    /// - Returns: A `URL` object if the `htmlUrlString` is valid; otherwise, `nil`.
    var htmlUrl: URL? {
        guard let htmlUrlString = htmlUrlString else { return nil }
        return URL(string: htmlUrlString)
    }
}

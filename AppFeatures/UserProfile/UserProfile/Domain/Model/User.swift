//
//  User.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation
import ObjectMapper

/// A model representing a user, conforming to the `Mappable` protocol for JSON mapping.
struct User: Equatable, Codable, Mappable {
    // MARK: - Properties
    
    /// The unique identifier for the user.
    var id: Int?
    
    /// The username or login identifier of the user.
    var login: String?
    
    /// The URL string pointing to the user's avatar image.
    var avatarUrlString: String?
    
    /// The URL string pointing to the user's profile page.
    var htmlUrlString: String?
    
    /// The location of the user, if available.
    var location: String?
    
    /// The number of followers the user has.
    var followers: Int?
    
    /// The number of users the user is following.
    var following: Int?
    
    // MARK: - Initializer
    
    /// Initializes the `User` object from a JSON map.
    ///
    /// This initializer is required by the `Mappable` protocol and is called during JSON parsing.
    ///
    /// - Parameter map: The `Map` object provided by ObjectMapper to map JSON data to the model's properties.
    public init?(map: Map) {}
}

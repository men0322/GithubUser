//
//  UserDefaultWrapper.swift
//  Common
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation

// MARK: - AnyOptional Protocol

/// A protocol to detect if an instance is nil.
/// This is specifically designed to handle optional values in Swift.
public protocol AnyOptional {
    /// A computed property to check if the instance is nil.
    var isNil: Bool { get }
}

// Conforming `Optional` to `AnyOptional`.
extension Optional: AnyOptional {
    /// Returns `true` if the optional is `nil`, otherwise `false`.
    public var isNil: Bool { self == nil }
}

// MARK: - UserDefaultWrapper

/// A property wrapper to simplify the use of `UserDefaults` for storing and retrieving values.
///
/// - Supports specifying a key, default value, and custom `UserDefaults` instance.
/// - Automatically handles optional values by removing the value from `UserDefaults` if set to `nil`.
@propertyWrapper
public struct UserDefaultWrapper<T: Equatable> {
    
    // MARK: Properties

    /// The key used to store the value in `UserDefaults`.
    public var key: String
    
    /// The default value returned if no value is found for the key in `UserDefaults`.
    public var defaultValue: T
    
    /// The `UserDefaults` instance to use. Defaults to `.standard`.
    public var userDefaults: UserDefaults = .standard

    // MARK: Initializer

    /// Initializes the property wrapper with a key, default value, and optional `UserDefaults` instance.
    ///
    /// - Parameters:
    ///   - key: The key used to store and retrieve the value in `UserDefaults`.
    ///   - defaultValue: The default value to return if no value is found for the key.
    ///   - userDefaults: The `UserDefaults` instance to use. Defaults to `.standard`.
    public init(key: String,
                defaultValue: T,
                userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    // MARK: Wrapped Value

    /// The value stored in `UserDefaults` for the specified key.
    ///
    /// - Getter: Returns the value from `UserDefaults` if it exists, otherwise returns the default value.
    /// - Setter: Updates the value in `UserDefaults`. If the value is an optional and set to `nil`, it removes the value from `UserDefaults`.
    public var wrappedValue: T {
        get {
            // Retrieve the value from UserDefaults, or return the default value if not found.
            return userDefaults.object(forKey: key) as? T ?? defaultValue
        }

        set {
            // If the new value is an optional and nil, remove the key from UserDefaults.
            if let optional = newValue as? AnyOptional, optional.isNil {
                userDefaults.removeObject(forKey: key)
                return
            }
            // Otherwise, set the new value in UserDefaults.
            userDefaults.set(newValue, forKey: key)
        }
    }
}

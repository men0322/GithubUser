//
//  Constants+API.swift
//  ApiClient
//
//  Created by Nguyen Hung on 09/12/2024.
//

import Foundation

/// A container for constants related to API configuration and response statuses.
enum Constants {
    
    /// A namespace for API configuration constants.
    enum CTAPIConfig {
        
        /// The base URL for the API.
        /// - Currently set to GitHub's API.
        static var baseURL: String {
            return "https://api.github.com/"
        }
        
        /// The timeout interval for API requests, in seconds.
        /// - Configured as 1000 seconds (1 * 1000).
        static let timeout = TimeInterval(1 * 1000)
    }
    
    /// Enum representing possible statuses in an API response.
    /// - `success`: Indicates the API request was successful.
    /// - `error`: Indicates the API request failed or encountered an error.
    public enum APIResponseStatus: String {
        case success = "success"
        case error   = "error"
    }
}

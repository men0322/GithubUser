//
//  NetworkManager.swift
//  ApiClient
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation
import Alamofire

/// A singleton class to manage network reachability using Alamofire's `NetworkReachabilityManager`.
class NetworkManager {
    /// Shared singleton instance of `NetworkManager`.
    static let shared = NetworkManager()
    
    /// Private initializer to enforce the singleton pattern.
    private init() {}
    
    /// A `NetworkReachabilityManager` instance to monitor network reachability.
    /// Monitors the reachability of the specified host ("www.google.com").
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    
    /// Starts observing network reachability changes.
    ///
    /// This function begins listening for reachability status updates and performs
    /// actions based on the current network status. Possible statuses are:
    /// - `.notReachable`: The network is not reachable.
    /// - `.unknown`: The network status is unknown.
    /// - `.reachable`: The network is reachable.
    public func startNetworkReachabilityObserver() {
        // Starts listening for reachability updates.
        reachabilityManager?.startListening(onUpdatePerforming: { status in
            switch status {
            case .notReachable, .unknown:
                // Handle the case when the network is not reachable or status is unknown.
                print("Network is not reachable or unknown.")
                break
                
            case .reachable(let connectionType):
                // Handle the case when the network is reachable.
                // Connection type can be `.ethernetOrWiFi` or `.cellular`.
                switch connectionType {
                case .ethernetOrWiFi:
                    print("Network is reachable via WiFi.")
                    
                case .cellular:
                    print("Network is reachable via Cellular.")
                }
                break
            }
        })
    }
}

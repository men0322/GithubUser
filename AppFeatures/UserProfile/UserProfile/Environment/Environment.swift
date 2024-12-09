//
//  Environment.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation

protocol EnvironmentType {
    var defaultAssembler: Assembler { get }
}

struct Environment: EnvironmentType {
    fileprivate static var stack: [EnvironmentType] = [Environment()]
    
    var defaultAssembler: Assembler = DefaultAssembler()
    
    // The most recent environment on the stack.
    public static var current: EnvironmentType {
        guard let last = stack.last else {
            fatalError("Cannot get current Environment")
        }
        return last
    }
    
    // Push a new environment onto the stack.
    static func pushEnvironment(_ env: EnvironmentType) {
        stack.append(env)
    }
    
    // Pop an environment off the stack.
    @discardableResult
    static func popEnvironment() -> EnvironmentType? {
        return stack.popLast()
    }
    
    // Replace the current environment with a new environment.
    static func replaceCurrentEnvironment(_ env: EnvironmentType) {
        pushEnvironment(env)
        stack.remove(at: stack.count - 2)
    }
}


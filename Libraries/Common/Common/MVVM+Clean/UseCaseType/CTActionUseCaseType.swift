//
//  ActionUseCaseType.swift
//  CTCommon
//
//  Created by Nguyen Hung on 09/12/2024.
//

import Foundation
import Action

public protocol ActionUseCaseType {
    associatedtype Output
    associatedtype Input

    var action: Action<Input, Output>? { get }
}

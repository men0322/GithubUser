//
//  CTViewModelType.swift
//  CTCommon
//
//  Created by Nguyen Hung on 09/12/2024.
//

import Foundation
import RxSwift

public protocol ViewModelType {
    var disposeBag: DisposeBag { get }
    func didBecomeActive()
}

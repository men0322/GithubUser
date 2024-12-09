//
//  NormalUseCaseType.swift
//  CTCommon
//
//  Created by Nguyen Hung on 09/12/2024.
//

import Foundation
import RxSwift

public protocol UseCaseType {
    associatedtype Output
    associatedtype Input
    func run(
        input: Input
    ) -> Output
}

extension UseCaseType {
    public func execute(
        input: Input
    ) -> Output {

        self.run(
            input: input
        )
    }
}

extension UseCaseType where Input == Void {
    public func execute() -> Output {
        run(input: ())
    }
}

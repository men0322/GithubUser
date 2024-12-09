//
//  Observable+bind.swift
//  CTCommon
//
//  Created by Nguyen Hung on 09/12/2024.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType where Element == Bool {
    /// Boolean not operator
    public func not() -> Observable<Bool> {
        return self.map(!)
    }
}

extension ObservableType {

    /**
     Invokes an action for each Next event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - parameter onNext: Action to invoke for each element in the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    // @warn_unused_result(message:"http://git.io/rxs.uo")
    func doOnNext(_ onNext: @escaping (Element) throws -> Void) -> Observable<Element> {
        return self.do(onNext: onNext)
    }

    /**
     Invokes an action for the Error event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - parameter onError: Action to invoke upon errored termination of the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    // @warn_unused_result(message:"http://git.io/rxs.uo")
    func doOnError(_ onError: @escaping (Swift.Error) throws -> Void) -> Observable<Element> {
        return self.do(onError: onError)
    }

    /**
     Invokes an action for the Completed event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - parameter onCompleted: Action to invoke upon graceful termination of the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    // @warn_unused_result(message:"http://git.io/rxs.uo")
    func doOnCompleted(_ onCompleted: @escaping () throws -> Void) -> Observable<Element> {
        return self.do(onCompleted: onCompleted)
    }

    /**
     Subscribes an element handler to an observable sequence.
     
     - parameter onNext: Action to invoke for each element in the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    // @warn_unused_result(message: "http://git.io/rxs.ud")
    func subscribeNext(_ onNext: @escaping (Element) -> Void) -> Disposable {
        return self.subscribe(onNext: onNext)
    }

    /**
     Subscribes an error handler to an observable sequence.
     
     - parameter onError: Action to invoke upon errored termination of the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    // @warn_unused_result(message: "http://git.io/rxs.ud")
    func subscribeError(_ onError: @escaping (Swift.Error) -> Void) -> Disposable {
        return self.subscribe(onError: onError)
    }

    /**
     Subscribes a completion handler to an observable sequence.
     
     - parameter onCompleted: Action to invoke upon graceful termination of the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    // @warn_unused_result(message: "http://git.io/rxs.ud")
    func subscribeCompleted(_ onCompleted: @escaping () -> Void) -> Disposable {
        return self.subscribe(onCompleted: onCompleted)
    }
}

// MARK: - RxCocoa

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {

    /**
     Invokes an action for each Next event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - parameter onNext: Action to invoke for each element in the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    // @warn_unused_result(message:"http://git.io/rxs.uo")
    func doOnNext(_ onNext: @escaping (Element) -> Void) -> Driver<Element> {
        return self.do(onNext: onNext)
    }

    /**
     Invokes an action for the Completed event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - parameter onCompleted: Action to invoke upon graceful termination of the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    // @warn_unused_result(message:"http://git.io/rxs.uo")
    func doOnCompleted(_ onCompleted: @escaping () -> Void) -> Driver<Element> {
        return self.do(onCompleted: onCompleted)
    }

    /**
     Subscribes an element handler to an observable sequence.
     
     - parameter onNext: Action to invoke for each element in the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    // @warn_unused_result(message: "http://git.io/rxs.ud")
    func driveNext(_ onNext: @escaping (Element) -> Void) -> Disposable {
        return self.drive(onNext: onNext)
    }

    /**
     Subscribes a completion handler to an observable sequence.
     
     - parameter onCompleted: Action to invoke upon graceful termination of the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    // @warn_unused_result(message: "http://git.io/rxs.ud")
    func driveCompleted(_ onCompleted: @escaping () -> Void) -> Disposable {
        return self.drive(onCompleted: onCompleted)
    }
}

// MARK: - ObservableType Extensions
extension ObservableType {

    /// Filters out `nil` values from an observable sequence and unwraps optional values.
    /// - Returns: An observable sequence containing only the non-nil elements of the original sequence.
    public func unwrap<T>() -> Observable<T> where Element == T? {
        return self
            .filter { value in
                // Filters out nil values.
                if case .some = value {
                    return true
                }
                return false
            }.map { $0! } // Force-unwraps the remaining non-nil values.
    }
    
    /// Catches an error in the observable sequence and completes the sequence instead of propagating the error.
    /// - Returns: An observable sequence that completes on error.
    public func catchErrorJustComplete() -> Observable<Element> {
        return `catch` { _ in
            return Observable.empty()
        }
    }
    
    /// Converts the observable sequence to a driver that completes on error.
    /// - Returns: A `Driver` that suppresses errors by completing.
    public func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in
            return Driver.empty()
        }
    }
    
    /// Maps all elements in the observable sequence to `Void`.
    /// - Returns: An observable sequence of type `Void`.
    public func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
    /// Converts all elements in the observable sequence to optional values.
    /// - Returns: An observable sequence of optional elements.
    public func mapToOptional() -> Observable<Element?> {
        return map { value -> Element? in value }
    }
    
    /// Logs each emitted element along with the thread name.
    /// - Returns: The same observable sequence, with added logging.
    public func dump() -> Observable<Self.Element> {
        return self.do(onNext: { element in
            let threadName = getThreadName()
            print("[D] \(element) received on \(threadName)")
        })
    }
    
    /// Subscribes to the observable sequence and logs each emitted element with the thread name.
    /// - Returns: A disposable representing the subscription.
    public func dumpingSubscription() -> Disposable {
        return self.subscribe(onNext: { element in
            let threadName = getThreadName()
            print("[S] \(element) received on \(threadName)")
        })
    }
}

// MARK: - SharedSequenceConvertibleType Extensions
extension SharedSequenceConvertibleType {
    
    /// Maps all elements in the shared sequence to `Void`.
    /// - Returns: A shared sequence of type `Void`.
    public func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
    
    /// Converts all elements in the shared sequence to optional values.
    /// - Returns: A shared sequence of optional elements.
    public func mapToOptional() -> SharedSequence<SharingStrategy, Element?> {
        return map { value -> Element? in value }
    }
    
    /// Filters out `nil` values from a shared sequence and unwraps optional values.
    /// - Returns: A shared sequence containing only the non-nil elements.
    public func unwrap<T>() -> SharedSequence<SharingStrategy, T> where Element == T? {
        return self
            .filter { value in
                // Filters out nil values.
                if case .some = value {
                    return true
                }
                return false
            }.map { $0! } // Force-unwraps the remaining non-nil values.
    }
}

// MARK: - Utility Functions

/// Retrieves the name of the current thread.
/// - Returns: A string representing the thread name, or a default value for unnamed threads.
private func getThreadName() -> String {
    if Thread.current.isMainThread {
        return "Main Thread"
    } else if let name = Thread.current.name {
        return name.isEmpty ? "Anonymous Thread" : name
    } else {
        return "Unknown Thread"
    }
}

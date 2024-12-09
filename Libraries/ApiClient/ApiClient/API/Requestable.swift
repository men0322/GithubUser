//
//  Requestable.swift
//  ApiClient
//
//  Created by Nguyen Hung on 09/12/2024.
//

import Foundation
import RxSwift
import ObjectMapper
import Alamofire

/// A shared Alamofire session manager with default configurations.
struct CEAlamofire {
    /// A singleton instance of `CEAlamofire`.
    static var `default` = CEAlamofire()
    private init() {}
    
    /// Lazy-initialized Alamofire session manager with default headers.
    lazy var sessionManager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = HTTPHeaders.default
        return Alamofire.Session(
            configuration: configuration
        )
    }()
}

/// A protocol defining a requestable object for API calls.
public protocol Requestable: URLRequestConvertible {
    associatedtype Output  // The expected output type for the API response.
    
    /// Base URL for the API.
    var basePath: String { get }
    
    /// Endpoint specific to the API call.
    var endpoint: String { get }
    
    /// HTTP method used for the API call.
    var httpMethod: HTTPMethod { get }
    
    /// Parameters for the API request.
    var params: Parameters { get }
    
    /// Default headers sent with the API request.
    var defaultHeaders: HTTPHeaders { get }
    
    /// Additional headers that can be customized.
    var additionalHeaders: HTTPHeaders { get }
    
    /// Encoding strategy for the parameters.
    var parameterEncoding: ParameterEncoding { get }
    
    /// The acceptable HTTP status codes for the response.
    var statusCode: Range<Int> { get }
    
    /// The acceptable content types for the response.
    var contentType: [String] { get }
    
    /// The queue on which the request is executed.
    var queue: DispatchQueue { get }
    
    /// Executes the API call and returns an observable.
    func execute() -> Observable<Output>
    
    /// Decodes the response data into the expected output type.
    func decode(data: Any) -> Output
}

/// Default implementation for `Requestable`.
public extension Requestable {
    var basePath: String {
        return Constants.CTAPIConfig.baseURL
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var params: Parameters {
        return [:]
    }
    
    var defaultHeaders: HTTPHeaders {
        return ["Accept": "application/json"]
    }
    
    var additionalHeaders: HTTPHeaders {
        return [:]
    }
    
    var urlPath: String {
        return basePath + endpoint
    }
    
    var customData: Data {
        return Data()
    }
    
    var url: URL {
        return URL(string: urlPath)!
    }
    
    var parameterEncoding: ParameterEncoding {
        switch httpMethod {
        case .post, .put, .delete, .patch:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    var statusCode: Range<Int> {
        return 200..<401
    }
    
    var contentType: [String] {
        return ["application/json", "text/plain"]
    }
    
    var queue: DispatchQueue {
        return DispatchQueue.global(qos: .default)
    }
    
    /// Executes the API call and returns an observable of the output type.
    @discardableResult
    func execute() -> Observable<Output> {
        return asObservable()
    }
    
    /// Builds a URLRequest with the defined properties.
    fileprivate func buildURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.timeoutInterval = Constants.CTAPIConfig.timeout
        urlRequest = try parameterEncoding.encode(urlRequest, with: params)
        
        defaultHeaders.forEach { header in
            urlRequest.addValue(header.value, forHTTPHeaderField: header.name)
        }
        
        additionalHeaders.forEach { header in
            urlRequest.addValue(header.value, forHTTPHeaderField: header.name)
        }
        
        return urlRequest
    }
    
    /// Makes the network request using Alamofire and executes the completion block with the response.
    func connectWithRequest(
        _ urlRequest: URLRequest,
        complete: @escaping (AFDataResponse<Data?>) -> Void
    ) -> DataRequest? {
        let sessionManager = CEAlamofire.default.sessionManager
        return httpRequest(urlRequest: urlRequest,
                           sessionManager: sessionManager,
                           complete: complete)
    }
    
    /// Sends the network request and validates the response.
    private func httpRequest(
        urlRequest: URLRequest,
        sessionManager: Session,
        complete: @escaping (AFDataResponse<Data?>) -> Void
    ) -> DataRequest {
        let request = sessionManager.request(urlRequest)

        debugPrint(request) // Debugging output for the request.

        requestData(request: request, complete: complete)
    
        return request
    }
    
    /// Validates the response and triggers the completion block with the result.
    private func requestData(
        request: DataRequest,
        complete: @escaping (AFDataResponse<Data?>) -> Void
    ) {
        request.validate(statusCode: statusCode)
        request.validate(contentType: contentType)
    
        request
            .response(completionHandler: { response in
                complete(response)
            })
    }
    
    /// Converts the request into an RxSwift Observable.
    private func asObservable() -> Observable<Output> {
        return Observable.create { observer in
            guard let urlRequest = try? self.asURLRequest() else {
                observer.onError(NSError(domain: "Can't create urlReqest", code: 2))
                return Disposables.create()
            }
            
            let connection = self.connectWithRequest(urlRequest, complete: { response in
                debugPrint(response)
                switch response.result {
                case let .success(data):
                    if let data = data,
                       let dict = try? JSONSerialization.jsonObject(with: data, options: []) {
                        observer.onNext(self.decode(data: dict))
                        observer.onCompleted()
                    } else {
                        observer.onError(NSError(domain: "Can't parse response data", code: 1))
                    }
                    
                case let .failure(error):
                    observer.onError(error)
                }
            })
            
            return Disposables.create {
                connection?.cancel()
            }
        }
    }
}

// MARK: - Conform URLRequestConvertible from Alamofire
public extension Requestable {
    /// Converts the request into a URLRequest using Alamofire's URLRequestConvertible protocol.
    func asURLRequest() throws -> URLRequest {
        return try buildURLRequest()
    }
}

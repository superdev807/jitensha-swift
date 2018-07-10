//
//  APIManager.swift
//  jitensha
//
//  Created by Benjamin Chris on 12/12/17.
//  Copyright © 2017 crossover. All rights reserved.
//

import RxSwift
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

enum APIManager {
    case placesList
    case register(user: User)
    case login(user: User)
    case createPayment(payment: PaymentRequest)
    case payments
}

extension APIManager {
    
    /**
     Endpoint base url and request method
     sometimes, we might need to call any other 3rd party api that is not from base url
     */
    
    fileprivate var urlAndMethod: (String, Alamofire.HTTPMethod) {
        
        let apiBaseURL = AppConfig.configApiBaseUrl
        
        switch self {
        case .placesList:
            return (apiBaseURL, .get)
        case .register:
            return (apiBaseURL, .put)
        case .login:
            return (apiBaseURL, .post)
        case .createPayment:
            return (apiBaseURL, .put)
        case .payments:
            return (apiBaseURL, .get)
        }
    }
    
    /**
     Sub Url and parameters / query
     */
    
    var endPoint: (path: String, params: [String: Any]?) {
        switch self{
        case .placesList:
            return ("places/", [:])
        case .register(let user):
            return ("users/", user.toJSON())
        case .login(let user):
            return ("users/", user.toJSON())
        case .createPayment(let payment):
            print(payment.toJSONString() ?? "")
            return ("payments/", payment.toJSON())
        case .payments:
            return ("payments/", [:])
        }
    }
    
    /**
     Main key value of response
     */
    var keyPath: String? {
        switch self {
        case .placesList:
            return "places"
        case .payments:
            return "payments"
        default:
            return nil
        }
    }
}

extension APIManager: URLRequestConvertible {
    
    func asURLRequest() throws -> URLRequest {
        
        let (baseURL, httpMethod) = urlAndMethod
        
        guard let url = URL(string: baseURL + endPoint.path) else {
            fatalError( "[APIManager] URL invalid for \(self)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        if let token = AppManager.shared.token {
            switch self {
            case .placesList:
                break
            default:
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }
        
        var encodedURLRequest: URLRequest
        let params: [String: Any]? = endPoint.params
        switch self {
        case .placesList, .payments:
            encodedURLRequest = try URLEncoding.queryString.encode(request as URLRequestConvertible, with: params)
        default:
            encodedURLRequest = try JSONEncoding.default.encode(request as URLRequestConvertible, with: params)
        }
        
        if encodedURLRequest.url != nil {
            print("[APIManager] \(endPoint.path)")
        }
        
        return encodedURLRequest
    }
}

extension APIManager {
    
    static func getList<T: Model>(_ r: APIManager) -> Observable<[T]> {
        return Observable.create({ (observer: AnyObserver<[T]>) -> Disposable in
            let request = manager.request(r).responseArray(queue: DispatchQueue.global(), keyPath: r.keyPath, completionHandler: { (response: DataResponse<[T]>) -> Void in
                if response.result.error != nil {
                    observer.onError(APIManagerError.incorrectDataError(reason: "[APIManager] Incorrect content"))
                } else if let value = response.result.value {
                    observer.onNext(value)
                    observer.onCompleted()
                } else {
                    observer.onNext([])
                    observer.onCompleted()
                }
            })
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    static func postObject<T: Model>(_ r: APIManager) -> Observable<T> {
        return Observable.create({ (observer: AnyObserver<T>) -> Disposable in
            let request = manager.request(r).responseObject(queue: DispatchQueue.global(), keyPath: r.keyPath, completionHandler: { (response: DataResponse<T>) -> Void in
                if response.result.error != nil {
                    if response.data != nil, let error = String(data: response.data!, encoding: .utf8) {
                        print("[APIManager] Error: \(error)")
                    }
                    observer.onError(APIManagerError.incorrectDataError(reason: "[APIManager] Incorrect content"))
                } else if let value = response.result.value {
                    observer.onNext(value)
                    observer.onCompleted()
                } else {
                    observer.onError(APIManagerError.missingDataError(reason: "[APIManager] Missing content"))
                    observer.onCompleted()
                }
            })
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    static var manager: SessionManager = {
        var defaultHeaders = SessionManager.default.session.configuration.httpAdditionalHeaders ?? [:]
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders
        
        return SessionManager(configuration: configuration)
    }()
}

enum APIManagerError: Error {
    case parseError(reason: String)
    case missingDataError(reason: String)
    case incorrectDataError(reason: String)
}


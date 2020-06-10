//
//  RequestService.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

struct EmptyParams {}
struct EmptyResponse: Codable {}

class RequestService {
    static let acceptableStatusCodes: CountableRange<Int> = 200..<300
    static let kBaseUrl = Constants.kBaseUrl
    static let disposeBag = DisposeBag()

    static var defaultHeaders: [String: String] {
        let headers = defaultHeadersWithoutAccessToken
        return headers
    }

    static var defaultHeadersWithoutAccessToken: [String: String] {
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json; charset=UTF-8"
        ]
        return headers
    }

    fileprivate class func acceptableContentType(_ headers: [String: String]?) -> [String] {
        if let dictionary = headers, let accept = dictionary["Accept"] {
            return accept.components(separatedBy: ",")
        }

        return ["*/*"]
    }

    fileprivate static let alamofireManager: Session = {
        let configuration = URLSessionConfiguration.default
        var serverTrustManager: ServerTrustManager?

        configuration.timeoutIntervalForResource = Constants.kDefaultRequestTimeout
        return Session(configuration: configuration, serverTrustManager: serverTrustManager)
    }()

    class func requestJSON<RequestParameters, T: Codable>(_ path: String,
                                                          params: RequestParameters,
                                                          method: Alamofire.HTTPMethod,
                                                          encoding: ParameterEncoding = JSONEncoding.default,
                                                          timeout: TimeInterval = Constants.kDefaultRequestTimeout) -> Single<T> {
        var request: URLRequest?
        guard let url = URL(string: kBaseUrl + (path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")) else {
            return Single.error(RequestError.ErrorType.urlNotValid)
        }
        do {
            request = try URLRequest(url: url, method: method, headers: HTTPHeaders(self.defaultHeaders)).encoded(with: params, encoding: encoding)
        } catch {
            return Single.error(RequestError.ErrorType.createURLRequestFailed)
        }

        guard let urlRequest = request else {
            return Single.error(RequestError.ErrorType.createURLRequestFailed)
        }
        return self.request(request: urlRequest, headers: self.defaultHeaders).flatMap({ data -> Single<T> in
            self.handleResponse(data)
        }).catchError({ error -> Single<T> in
            return Single.error(error)
        })
    }

    private class func request(request: URLRequest, headers: [String: String]) -> Single<AFDataResponse<Data?>> {
        return Single.create { observer -> Disposable in
            var request = request
            request.allHTTPHeaderFields = headers
            alamofireManager.request(request)
                .validate(contentType: acceptableContentType(headers))
                .response { response in
                    switch response.result {
                    case .success:
                        observer(.success(response))
                    case .failure(let error):
                        observer(.error(error))
                    }
                }
            return Disposables.create()
        }
    }

    private class func handleResponse<T: Codable>(_ response: AFDataResponse<Data?>) -> Single<T> {
        guard let statusCode = response.response?.statusCode, acceptableStatusCodes ~= statusCode else {
            return handleError(response)
        }
        return handleData(response)
    }

    private class func handleData<T: Codable>(_ data: AFDataResponse<Data?>) -> Single<T> {
        return Single.create { single -> Disposable in
            if let modelData = data.data {
                do {
                    let model = try JSONDecoder().decode(T.self, from: modelData)
                    single(.success(model))
                } catch {
                    single(.error(error))
                }
            } else {
                do {
                    let model = try JSONDecoder().decode(T.self, from: "{}".data(using: .ascii) ?? Data())
                    single(.success(model))
                } catch {
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    private class func handleError<T: Codable>(_ data: AFDataResponse<Data?>) -> Single<T> {
        return Single.create { single -> Disposable in
            do {
                guard let responseData = data.data else {
                    single(.error(RequestError.ErrorType.reponseDataNotPresent))
                    return Disposables.create()
                }
                let model: RequestError = try JSONDecoder().decode(RequestError.self, from: responseData)
                single(.error(model))
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        }
    }
}

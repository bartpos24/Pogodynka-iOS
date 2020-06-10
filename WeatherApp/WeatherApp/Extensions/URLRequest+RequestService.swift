//
//  URLRequest+RequestService.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Alamofire
import Foundation
import Wrap

extension URLRequest {
    init?(path: String, method: Alamofire.HTTPMethod, timeout: TimeInterval = Constants.kDefaultRequestTimeout) {
        guard let endpoint = URL(string: path) else { return nil }

        self.init(url: endpoint)
        self.httpMethod = method.rawValue
        self.timeoutInterval = timeout
    }

    func encoded<RequestParameters>(with params: RequestParameters, encoding: ParameterEncoding = JSONEncoding.default) -> URLRequest {
        let parameters = params is EmptyParams ? nil : URLRequest.wrapRequest(parameters: params)
        if let encoded = try? encoding.encode(self, with: parameters) {
            return encoded
        }

        return self
    }

    private static func wrapRequest<T>(parameters: T) -> WrappedDictionary {
        do {
            let dictionary: WrappedDictionary = try wrap(parameters)
            return dictionary
        } catch {
            print("Can not wrap: \(error)")
        }

        return WrappedDictionary()
    }
}

//
//  RequestError.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation

enum ErrorCode: Int {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case conflict = 409
    case outdatedAPI = 410
    case databaseValidation = 422
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503

    case requestNotValid = -203
    case emptyResponse = -204
}

struct RequestError: Error, Codable {
    var statusCode: Int?
    var data: Data?
    var message: String?
    var errorCode: String?
    var key: String?
    var value: String?

    var localizedFailure: String {
        switch statusCode {
        case URLError.notConnectedToInternet.rawValue, URLError.networkConnectionLost.rawValue, URLError.dnsLookupFailed.rawValue:
            return "Request_error_not_connected_to_internet"
        case URLError.cannotLoadFromNetwork.rawValue:
            return "Request_error_secure_connection_failed"
        case URLError.cannotConnectToHost.rawValue:
            return "Request_error_cannot_connect_to_host"
        case ErrorCode.badRequest.rawValue:
            return "Request_error_bad_request"
        case ErrorCode.unauthorized.rawValue:
            return "Request_error_unauthorized"
        case ErrorCode.forbidden.rawValue:
            return "Request_error_forbidden"
        case ErrorCode.conflict.rawValue:
            return  "Request_error_conflict"
        case ErrorCode.databaseValidation.rawValue:
            return "Request_error_database_validation"
        case ErrorCode.internalServerError.rawValue:
            return "Request_error_internal_server_error"
        case ErrorCode.notImplemented.rawValue:
            return "Request_error_not_implemented"
        case ErrorCode.badGateway.rawValue:
            return "Request_error_bad_gateway"
        case ErrorCode.serviceUnavailable.rawValue:
            return "Request_error_service_unavailable"
        case ErrorCode.requestNotValid.rawValue:
            return "Request_error_empty_response"
        case ErrorCode.emptyResponse.rawValue:
            return "Request_error_empty_response"
        default:
            return "Unknown error \(String(describing: statusCode))"
        }
    }

    enum ErrorType: Error {
        case urlNotValid
        case createURLRequestFailed
        case urlPathNotValid
        case requestDataNotPresent
        case reponseDataNotPresent
    }
}

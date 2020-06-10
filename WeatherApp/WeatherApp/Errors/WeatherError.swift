//
//  WeatherError.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 03/06/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation

class WeatherError: GenericError {
    var message: String?
    var errorCode: String?
    var type: ErrorType = .weather
    var key: String?
    var value: String?

    init(message: String) {
        self.message = message
    }

    init(error: RequestError) {
        self.message = error.message
        self.errorCode = error.errorCode
        self.key = error.key
        self.value = error.value
    }
}

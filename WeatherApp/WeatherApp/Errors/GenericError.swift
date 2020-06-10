//
//  GenericError.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 03/06/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation

enum ErrorType {
    case weather
}

protocol GenericError: Error {
    var type: ErrorType { get set }
}

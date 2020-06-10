//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct WeatherMain: Codable {
    var temp: Double?
    var pressure: Int?
    var humidity: Int?
    var temp_min: Double?
    var temp_max: Double?
}

struct Wind: Codable {
    var speed: Double?
    var deg: Int?
}

struct Clouds: Codable {
    var all: Int?
}

struct Sys: Codable {
    var type: Int?
    var id: Int?
    var message: Double?
    var country: String?
    var sunrise: Int?
    var sunset: Int?
}

struct Weather: Codable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}

struct WeatherResponse: Codable {
    var id: Int?
    var name: String?
    var cod: Int?
    var coord: Coord?
    var weather: [Weather]
    var main: WeatherMain?
    var visibility: Int?
    var wind: Wind?
    var clouds: Clouds?
    var dt: Int?
    var sys: Sys?
}

struct Coord: Codable {
    var lon: Double
    var lat: Double
}

class WeatherAPI: RequestService {
    static let kPathUrl = "/weather"

    class func weather(_ id: Int) -> Single<WeatherResponse> {
        return requestJSON(WeatherAPI.kPathUrl + "?id=\(id)" + "&appid=\(Constants.kApiKey)", params: EmptyParams(), method: .get)
    }

    class func weatherForLocation(lat: Double, lon: Double) -> Single<WeatherResponse> {
        return requestJSON(WeatherAPI.kPathUrl + "?lat=\(lat)" + "&lon=\(lon)" + "&appid=\(Constants.kApiKey)", params: EmptyParams(), method: .get)
    }
}

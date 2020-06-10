//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 30/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherService {
    static let shared = WeatherService()
    var weather = BehaviorRelay<WeatherResponse?>(value: nil)
    var inProgress = BehaviorRelay<Bool>(value: false)
    private var disposeBag = DisposeBag()

    func udateWeather(_ id: Int) {
        inProgress.accept(true)
        WeatherAPI.weather(id)
            .asObservable()
            .map { weather in
                self.inProgress.accept(false)
                return weather
            }
            .bind(to: weather)
            .disposed(by: disposeBag)
    }

    func updateWeather(lat: Double, lon: Double) {
        inProgress.accept(true)
        WeatherAPI.weatherForLocation(lat: lat, lon: lon)
            .asObservable()
            .map { weather in
                self.inProgress.accept(false)
                return weather
            }
            .bind(to: weather)
            .disposed(by: disposeBag)
    }
}

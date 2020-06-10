//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherViewModel {
    private var id: Int?
    private var disposeBag = DisposeBag()

    var inProgress = BehaviorRelay<Bool>(value: true)
    var title = PublishSubject<String?>()
    var temperature = PublishSubject<Double?>()
    var sunrise = PublishSubject<Int?>()
    var sunset = PublishSubject<Int?>()
    var weatherMain = PublishSubject<String?>()
    var weatherDesc = PublishSubject<String?>()
    var pressure = PublishSubject<Int?>()
    var exampleData = ""
    var error = PublishSubject<WeatherError>()

    init(id: Int? = nil) {
        self.id = id
        if let cityId = id {
            WeatherService.shared.udateWeather(cityId)
        } else {
            #if arch(i386) || arch(x86_64)
            WeatherService.shared.udateWeather(3094802)
            #else
            fetchWithLocation()
            #endif
        }
        setupRx()
    }
}

extension WeatherViewModel {
    func setupRx() {
        WeatherService.shared.inProgress
            .bind(to: inProgress)
            .disposed(by: disposeBag)

        WeatherService.shared.weather
            .compactMap{ $0 }
            .subscribe(
                onNext: { [weak self] weather in
                    self?.temperature.onNext(weather.main?.temp)
                    self?.pressure.onNext(weather.main?.pressure)
                    self?.title.onNext(weather.name)
                    self?.sunrise.onNext(weather.sys?.sunrise)
                    self?.sunset.onNext(weather.sys?.sunset)
                    self?.weatherMain.onNext(weather.weather.first?.main)
                    self?.weatherDesc.onNext(weather.weather.first?.description)
                    self?.exampleData = "coś"
                },
                onError: { [weak self] error in
                    guard let requestError = error as? RequestError else {
                        print(error.localizedDescription)
                        return
                    }
                    let weatherError = WeatherError(error: requestError)
                    self?.error.onNext(weatherError)
                }
        ).disposed(by: disposeBag)
    }

    func fetchWithLocation() {
        LocationService.shared.requestAuthorization()
        LocationService.shared
            .userLocation
            .subscribe(
                onNext: { location in
                    WeatherService.shared.updateWeather(lat: location.latitude, lon: location.longitude)
                }
            ).disposed(by: disposeBag)
    }
}

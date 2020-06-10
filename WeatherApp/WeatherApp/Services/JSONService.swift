//
//  JSONService.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct Coordinates: Codable {
    var lon: Double
    var lat: Double
}

struct Country: Codable {
    var country: String
    var cities: [City]

    init(country: String, cities: [City]) {
        self.country = country
        self.cities = cities
    }
}

struct City: Codable {
    var id: Int
    var name: String
    var country: String
    var state: String
    var coord: Coordinates
}

class JSONService {
    static let shared = JSONService()
    var countries = BehaviorRelay<[Country]>(value: [])

    func cityList() {
        var allCountries = [Country]()
        DispatchQueue.global(qos: .background).async {
            if let url = Bundle.main.url(forResource: "city.list", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let jsonData = try JSONDecoder().decode([City].self, from: data)
                    jsonData.forEach { city in
                        let index = allCountries.firstIndex { $0.country == Iso3166_1a2(rawValue: city.country)?.country }
                        if let i = index {
                            allCountries[i].cities.append(city)
                        } else {
                            allCountries.append(Country(country: Iso3166_1a2(rawValue: city.country)?.country ?? "", cities: [city]))
                        }
                    }
                    DispatchQueue.main.async {
                        self.countries.accept(allCountries)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

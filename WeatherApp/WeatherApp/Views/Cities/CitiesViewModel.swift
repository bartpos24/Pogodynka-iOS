//
//  CitiesViewModel.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation

class CitiesViewModel {
    var cities: [City]
    var citiesOriginal: [City]

    init(cities: [City]) {
        self.cities = cities
        self.citiesOriginal = cities
    }
}

extension CitiesViewModel {
    func filter(with text: String) {
        cities = citiesOriginal
        guard !text.isEmpty else {
            return
        }
        let filtered = cities.filter { $0.name.lowercased().contains(text.lowercased()) }
        cities = filtered
    }
}

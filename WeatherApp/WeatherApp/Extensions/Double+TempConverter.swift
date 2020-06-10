//
//  Double+TempConverter.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation

extension Double {
    func toCelcius() -> Double {
        let x = self - 273.15
        let y = (x*10).rounded()/10
        return y
    }
}

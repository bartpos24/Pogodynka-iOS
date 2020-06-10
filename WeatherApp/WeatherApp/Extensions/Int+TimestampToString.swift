//
//  Int+TimestampToString.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 30/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation

extension Int {
    func toString(_ format: String = "hh:mm a") -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(self))

        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = format

        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
}

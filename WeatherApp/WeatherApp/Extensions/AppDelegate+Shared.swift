//
//  AppDelegate+Shared.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import UIKit

extension AppDelegate {
    static var shared: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("App Delegate doesn't exist, this should never happen")
        }
        return appDelegate
    }
}

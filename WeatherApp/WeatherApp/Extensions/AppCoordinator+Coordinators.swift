//
//  AppCoordinator+Coordinators.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation

extension AppCoordinator {
    func coordinator(of type: CoordinatorTypes) -> Coordinator? {
        return childCoordinators[type]
    }

    func add(coordinator: Coordinator?, type: CoordinatorTypes) {
        childCoordinators[type] = coordinator
    }

    func free(coordinator type: CoordinatorTypes) {
        childCoordinators = childCoordinators.filter { $0.key != type }
    }
}

extension AppCoordinator {
    var homeCoordinator: HomeCoordinator? {
        return coordinator(of: .home) as? HomeCoordinator
    }

    var weatherCoordinator: WeatherCoordinator? {
        return coordinator(of: .weather) as? WeatherCoordinator
    }
}

//
//  ChildCoordinatorSettable.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation

enum CoordinatorTypes {
    case home
    case city
    case weather
}

protocol ChildCoordinatorsSettable {
    var childCoordinators: [CoordinatorTypes: Coordinator] { get set }

    func coordinator(of type: CoordinatorTypes) -> Coordinator?
    func add(coordinator: Coordinator?, type: CoordinatorTypes)
    func free(coordinator type: CoordinatorTypes)
    func freeAllCoordinators()
}

extension ChildCoordinatorsSettable {
    func freeAllCoordinators() {
        childCoordinators.forEach { key, coordinator in
            (coordinator as? ChildCoordinatorsSettable)?.freeAllCoordinators()
            free(coordinator: key)
        }
    }
}

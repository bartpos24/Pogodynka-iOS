//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class AppCoordinator: Coordinator, ChildCoordinatorsSettable {
    private let rootViewController: UINavigationController
    let window: UIWindow!
    let disposeBag = DisposeBag()

    var childCoordinators: [CoordinatorTypes: Coordinator] = [:]

    init(window: UIWindow) {
        self.window = window
        self.rootViewController = UINavigationController()
    }
    
    func start() {
        JSONService.shared.cityList()
        goToMyWeatherScreen()
    }

    func goToMyWeatherScreen() {
        window.rootViewController = rootViewController
        let model = WeatherViewModel()
        add(coordinator: WeatherCoordinator(presenter: rootViewController, model: model), type: .weather)
        weatherCoordinator?.present()
        window.makeKeyAndVisible()
    }

    func goToHomeScreen() {
        window.rootViewController = rootViewController
        add(coordinator: HomeCoordinator(presenter: rootViewController), type: .home)
        homeCoordinator?.present()
        window.makeKeyAndVisible()
    }
}

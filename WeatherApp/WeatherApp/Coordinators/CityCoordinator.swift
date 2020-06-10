//
//  CityCoordinator.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol WeatherPresentable {
    func showWeather(for city: City)
}

typealias WeatherTransitionable = WeatherPresentable & Presentable

class CityCoordinator: Coordinator, LeaveNotifiable, ChildCoordinatorsSettable {
    var presenter: UINavigationController
    private var viewModel: CitiesViewModel!
    private var citiesViewController: CitiesViewController!
    var didLeaveScreen = PublishSubject<AnyObject?>()
    var childCoordinators: [CoordinatorTypes: Coordinator] = [:]

    init(presenter: UINavigationController, model: CitiesViewModel) {
        self.presenter = presenter
        viewModel = model
        citiesViewController = CitiesViewController.instantiate(with: viewModel, coordinator: self)
    }

    func start() {}

    func present(_ animated: Bool = true) {
        presenter.pushViewController(citiesViewController, animated: animated)
    }

    func leave(_ animated: Bool = true, completion: (() -> Void)? = nil) {
        presenter.popViewController(animated: animated) { [weak self] in
            self?.didLeaveScreen.onNext(nil)
        }
    }
}

extension CityCoordinator: WeatherTransitionable {
    func showWeather(for city: City) {
        WeatherService.shared.udateWeather(city.id)
        presenter.popBack(toControllerType: WeatherViewController.self)
    }
}

extension CityCoordinator {
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

extension CityCoordinator {
    var weatherCoordinator: WeatherCoordinator? {
        return coordinator(of: .weather) as? WeatherCoordinator
    }
}

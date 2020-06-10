//
//  WeatherCoordinator.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

protocol CountryShowable {
    func showCountryList()
}

class WeatherCoordinator: Coordinator, Presentable, LeaveNotifiable, ChildCoordinatorsSettable {
    private var viewModel: WeatherViewModel!
    private var weatherViewController: WeatherViewController!

    var didLeaveScreen = PublishSubject<AnyObject?>()
    var presenter: UINavigationController
    var childCoordinators: [CoordinatorTypes: Coordinator] = [:]
    var disposeBag = DisposeBag()

    init(presenter: UINavigationController, model: WeatherViewModel) {
        self.presenter = presenter
        viewModel = model
        weatherViewController = WeatherViewController.instantiate(with: viewModel, coordinator: self)
    }

    func start() {}

    func present(_ animated: Bool = true) {
        presenter.pushViewController(weatherViewController, animated: animated)
    }

    func leave(_ animated: Bool = true, completion: (() -> Void)? = nil) {
        presenter.popViewController(animated: animated) { [weak self] in
            self?.didLeaveScreen.onNext(nil)
        }
    }
}

extension WeatherCoordinator: CountryShowable {
    func showCountryList() {
        add(coordinator: HomeCoordinator(presenter: presenter), type: .home)
        homeCoordinator?.present()
        setupHomeCoordinatorRx()
    }
}

extension WeatherCoordinator {
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

extension WeatherCoordinator {
    var homeCoordinator: HomeCoordinator? {
        return coordinator(of: .home) as? HomeCoordinator
    }
}

extension WeatherCoordinator {
    func setupHomeCoordinatorRx() {
        homeCoordinator?.didLeaveScreen
            .subscribe(
                onNext: { [weak self] _ in
                    self?.free(coordinator: .home)
                }
        ).disposed(by: disposeBag)
    }
}

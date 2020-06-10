//
//  HomeCoordinator.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeCoordinator: Coordinator, Presentable, LeaveNotifiable, ChildCoordinatorsSettable {
    private var homeViewModel: HomeViewModel!
    private var homeViewController: HomeViewController!
    private var disposeBag = DisposeBag()

    var presenter: UINavigationController
    var childCoordinators: [CoordinatorTypes: Coordinator] = [:]
    var didLeaveScreen = PublishSubject<AnyObject?>()

    init(presenter: UINavigationController) {
        self.presenter = presenter
        homeViewModel = HomeViewModel()
        homeViewController = HomeViewController.instantiate(with: homeViewModel, coordinator: self)
    }

    func start() {
        
    }

    func present(_ animated: Bool = true) {
        presenter.pushViewController(homeViewController, animated: animated)
    }

    func leave(_ animated: Bool = true, completion: (() -> Void)? = nil) {
        presenter.popViewController(animated: animated) { [weak self] in
            self?.didLeaveScreen.onNext(nil)
        }
    }
}

extension HomeCoordinator {
    func showCities(of country: Country) {
        let model = CitiesViewModel(cities: country.cities)
        add(coordinator: CityCoordinator(presenter: presenter, model: model), type: .city)
        cityCoordinator?.present()
        setupCityCoordinatorRx()
    }
}

extension HomeCoordinator {
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

extension HomeCoordinator {
    var cityCoordinator: CityCoordinator? {
        return coordinator(of: .city) as? CityCoordinator
    }

    var weatherCoordinator: WeatherCoordinator? {
        return coordinator(of: .weather) as? WeatherCoordinator
    }
}

private extension HomeCoordinator {
    func setupCityCoordinatorRx() {
        cityCoordinator?.didLeaveScreen
            .subscribe(
                onNext: { [weak self] _ in
                    self?.free(coordinator: .city)
                }
        ).disposed(by: disposeBag)
    }

    func setupWeatherCoordinatorRx() {
        weatherCoordinator?.didLeaveScreen
            .subscribe(
                onNext: { [weak self] _ in
                    self?.free(coordinator: .weather)
                }
        ).disposed(by: disposeBag)
    }
}

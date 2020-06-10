//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import TPKeyboardAvoiding

class WeatherViewController: UIViewController {
    @UsesAutoLayout
    private var cityTitle = UILabel()
    @UsesAutoLayout
    private var sunriseLabel = UILabel()
    @UsesAutoLayout
    private var sunsetLabel = UILabel()
    @UsesAutoLayout
    private var temperatureLabel = UILabel()
    @UsesAutoLayout
    private var pressureLabel = UILabel()
    @UsesAutoLayout
    private var humidityLabel = UILabel()
    @UsesAutoLayout
    private var tempMinLabel = UILabel()
    @UsesAutoLayout
    private var tempMaxLabel = UILabel()
    @UsesAutoLayout
    private var weatherMainLabel = UILabel()
    @UsesAutoLayout
    private var weatherDescriptionLabel = UILabel()
    @UsesAutoLayout
    private var activityIndicator = UIActivityIndicatorView()
    private var contentScrollView = TPKeyboardAvoidingScrollView()

    @UsesAutoLayout
    private var exampleLabel = UILabel()

    private var viewModel: WeatherViewModel!
    private var disposeBag = DisposeBag()
    private var coordinator: CountryShowable!

    class func instantiate(with model: WeatherViewModel, coordinator: CountryShowable) -> WeatherViewController {
        let vc = WeatherViewController()
        vc.viewModel = model
        vc.coordinator = coordinator
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupLabels()
        setupLayout()
        setupRx()
        setupProgressRx()
        setupButtons()
        setupSnackbar()
    }
}

private extension WeatherViewController {
    func setupButtons() {
        let contryListButton = UIBarButtonItem(title: "Pogoda na świecie",
                                     style: .plain,
                                     target: self,
                                     action: #selector(showCountryList))

        let myWeatherButton = UIBarButtonItem(title: "Pogoda u mnie",
                                              style: .plain,
                                              target: self,
                                              action: #selector(showMyWeather))
        navigationItem.leftBarButtonItem = myWeatherButton
        navigationItem.rightBarButtonItem = contryListButton
    }

    @objc
    func showCountryList() {
        coordinator.showCountryList()
    }

    @objc
    func showMyWeather() {
        LocationService.shared.startUpdatingLocation()
    }
}

private extension WeatherViewController {
    func setupRx() {
        viewModel.title
            .compactMap { $0 }
            .bind(to: cityTitle.rx.text)
            .disposed(by: disposeBag)

        viewModel.temperature
            .compactMap { $0 }
            .map { temp in "\(String(temp.toCelcius()))°" }
            .bind(to: temperatureLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.pressure
            .compactMap { $0 }
            .map { pressure in "Ciśnienie: \(String(pressure)) hPa" }
            .bind(to: pressureLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.sunrise
            .compactMap { $0 }
            .map { sunrise in "Wschód słońca: \(sunrise.toString())" }
            .bind(to: sunriseLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.sunset
            .compactMap { $0 }
            .map { sunset in "Zachód słońca: \(sunset.toString())" }
            .bind(to: sunsetLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.weatherMain
            .compactMap { $0 }
            .map { weatherMain in "Pogoda: \(weatherMain)" }
            .bind(to: weatherMainLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.weatherDesc
            .compactMap { $0 }
            .bind(to: weatherDescriptionLabel.rx.text)
            .disposed(by: disposeBag)
    }

    func setupSnackbar() {
        viewModel.error
            .subscribe(
                onNext: { [weak self] error in
                    self?.showSnackbar(message: error.message ?? error.localizedDescription, bottomMargin: 42.0)
                }
            ).disposed(by: disposeBag)
    }

    func setupProgressRx() {
        viewModel.inProgress
            .subscribe(
                onNext: { [weak self] inProgress in
                    switch inProgress {
                    case true: self?.activityIndicator.startAnimating()
                    case false: self?.activityIndicator.stopAnimating()
                    }
                    self?.activityIndicator.isHidden = !inProgress
                }
        ).disposed(by: disposeBag)

        viewModel.inProgress
            .bind(to: cityTitle.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.inProgress
            .bind(to: temperatureLabel.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.inProgress
            .bind(to: pressureLabel.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.inProgress
            .bind(to: sunriseLabel.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.inProgress
            .bind(to: sunsetLabel.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.inProgress
            .bind(to: weatherMainLabel.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.inProgress
            .bind(to: weatherDescriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }

    func setupLabels() {
        temperatureLabel.setAppearance(.regularFont(size: 72.0))
        pressureLabel.setAppearance(.regularFont(size: 21.0))
        cityTitle.setAppearance(.regularFont(size: 26.0))
        sunriseLabel.setAppearance(.regularFont(size: 18.0))
        sunsetLabel.setAppearance(.regularFont(size: 18.0))
        weatherMainLabel.setAppearance(.regularFont(size: 16.0))
        weatherDescriptionLabel.setAppearance(.regularFont(size: 18.0))
    }

    func setupView() {
        contentScrollView.backgroundColor = .white
        contentScrollView.addSubview(cityTitle)
        contentScrollView.addSubview(sunsetLabel)
        contentScrollView.addSubview(sunriseLabel)
        contentScrollView.addSubview(temperatureLabel)
        contentScrollView.addSubview(pressureLabel)
        contentScrollView.addSubview(humidityLabel)
        contentScrollView.addSubview(tempMinLabel)
        contentScrollView.addSubview(tempMaxLabel)
        contentScrollView.addSubview(weatherMainLabel)
        contentScrollView.addSubview(weatherDescriptionLabel)
        contentScrollView.addSubview(activityIndicator)
        contentScrollView.addSubview(exampleLabel)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: contentScrollView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentScrollView.centerYAnchor),

            cityTitle.topAnchor.constraint(equalTo: contentScrollView.topAnchor, constant: 40.0),
            cityTitle.centerXAnchor.constraint(equalTo: contentScrollView.centerXAnchor),

            weatherMainLabel.topAnchor.constraint(equalTo: cityTitle.bottomAnchor, constant: 20.0),
            weatherMainLabel.centerXAnchor.constraint(equalTo: contentScrollView.centerXAnchor),

            temperatureLabel.topAnchor.constraint(equalTo: weatherMainLabel.topAnchor, constant: 30.0),
            temperatureLabel.centerXAnchor.constraint(equalTo: contentScrollView.centerXAnchor),

            pressureLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 20.0),
            pressureLabel.centerXAnchor.constraint(equalTo: contentScrollView.centerXAnchor),

            weatherDescriptionLabel.topAnchor.constraint(equalTo: pressureLabel.bottomAnchor, constant: 20.0),
            weatherDescriptionLabel.centerXAnchor.constraint(equalTo: contentScrollView.centerXAnchor),

            sunriseLabel.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: 60.0),
            sunriseLabel.centerXAnchor.constraint(equalTo: contentScrollView.centerXAnchor),

            sunsetLabel.topAnchor.constraint(equalTo: sunriseLabel.bottomAnchor, constant: 20.0),
            sunsetLabel.centerXAnchor.constraint(equalTo: contentScrollView.centerXAnchor),

            exampleLabel.topAnchor.constraint(equalTo: sunsetLabel.bottomAnchor, constant: 20.0),
            exampleLabel.centerXAnchor.constraint(equalTo: contentScrollView.centerXAnchor),

            sunsetLabel.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor)
        ])
        view = contentScrollView
    }
}

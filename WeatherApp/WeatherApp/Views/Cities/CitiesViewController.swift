//
//  CitiesViewController.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CitiesViewController: UIViewController {
    @UsesAutoLayout
    private var tableView = UITableView()
    @UsesAutoLayout
    private var searchBar = UISearchBar()
    private var disposeBag = DisposeBag()
    private var viewModel: CitiesViewModel!
    private var coordinator: WeatherTransitionable!

    class func instantiate(with model: CitiesViewModel, coordinator: WeatherTransitionable) -> CitiesViewController {
        let vc = CitiesViewController()
        vc.viewModel = model
        vc.coordinator = coordinator
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupLayout()
        setupTableView()
        setupBackButton()
    }
}

private extension CitiesViewController {
    func setupTableView() {
        tableView.register(CityTableViewCell.nib(),
                           forCellReuseIdentifier: CityTableViewCell.identifier)
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70.0
        tableView.backgroundColor = .veryLightPink
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView()
    }

    func setupView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(searchBar)
    }

    func setupLayout() {
        let topPadding = UIApplication.shared.topPadding
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 42.0 + topPadding),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 62.0),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupBackButton() {
        let button = UIBarButtonItem(title: "Powrót",
                                     style: .plain,
                                     target: self,
                                     action: #selector(goBack))
        navigationItem.leftBarButtonItem = button
    }

    @objc
    func goBack() {
        coordinator.leave(true, completion: nil)
    }
}

extension CitiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        LocationService.shared.stopUpdatingLocation()
        coordinator.showWeather(for: viewModel.cities[indexPath.row])
    }
}

extension CitiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier, for: indexPath) as? CityTableViewCell else {
            return UITableViewCell()
        }
        cell.setup(with: viewModel.cities[indexPath.row])
        return cell
    }
}

extension CitiesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filter(with: searchText)
        tableView.reloadData()
    }
}

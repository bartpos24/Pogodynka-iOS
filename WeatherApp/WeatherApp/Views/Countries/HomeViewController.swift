//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    private var viewModel: HomeViewModel!
    @UsesAutoLayout
    private var tableView = UITableView()
    @UsesAutoLayout
    private var searchBar = UISearchBar()
    private var disposeBag = DisposeBag()
    private var coordinator: HomeCoordinator!

    class func instantiate(with model: HomeViewModel, coordinator: HomeCoordinator) -> HomeViewController {
        let vc = HomeViewController()
        vc.viewModel = model
        vc.coordinator = coordinator
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupLayout()
        setupTableView()
        setupRx()
        setupBackButton()

        viewModel.fetch()
    }
}

private extension HomeViewController {
    func setupTableView() {
        tableView.register(HomeTableViewCell.nib(),
                           forCellReuseIdentifier: HomeTableViewCell.identifier)

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

    func setupRx() {
        viewModel.countries
            .subscribe(
                onNext: { [weak self] _ in
                    self?.tableView.reloadData()
                }
            ).disposed(by: disposeBag)
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
        coordinator.leave()
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        coordinator.showCities(of: viewModel.countries.value[indexPath.row])
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.countries.value.count == 0 {
            tableView.emptyState(message: "Data is being processed")
            return 0
        }
        tableView.backgroundView = nil
        return viewModel.countries.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        cell.setup(with: viewModel.countries.value[indexPath.row])
        return cell
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filter(with: searchText)
        tableView.reloadData()
    }
}

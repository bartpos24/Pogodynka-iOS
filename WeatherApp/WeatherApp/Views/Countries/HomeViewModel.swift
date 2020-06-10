//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    var countries = BehaviorRelay<[Country]>(value: [])
    private var disposeBag = DisposeBag()
}

extension HomeViewModel {
    func fetch() {
        JSONService.shared.countries
            .bind(to: countries)
            .disposed(by: disposeBag)
    }

    func filter(with text: String) {
        let allCounries = JSONService.shared.countries.value
        countries.accept(allCounries)
        guard !text.isEmpty else {
            return
        }
        let filtered = countries.value.filter { $0.country.lowercased().contains(text.lowercased()) }
        countries.accept(filtered)
    }
}

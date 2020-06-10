//
//  Presentable.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol ShowNotifiable {
    var didPresentScreen: PublishSubject<Void> { get set }
}

protocol LeaveNotifiable {
    var didLeaveScreen: PublishSubject<AnyObject?> { get set }
}

protocol Presentable {
    var presenter: UINavigationController { get set }

    func present(_ animated: Bool)
    func leave(_ animated: Bool, completion: (() -> Void)?)
}

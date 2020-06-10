//
//  UIViewController+Modal.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import UIKit

extension UIViewController {
    open func present(_ viewController: UIViewController, style: UIModalPresentationStyle, animated: Bool, completion: (() -> Void)? = nil) {
        viewController.modalPresentationStyle = style
        present(viewController, animated: animated, completion: completion)
    }
}

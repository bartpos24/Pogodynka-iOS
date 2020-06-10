//
//  UIApplication+TopViewController.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import UIKit

extension UIApplication {
    var topPadding: CGFloat {
        return self.keyWindow?.safeAreaInsets.top ?? 0
    }

    var bottomPadding: CGFloat {
        return self.keyWindow?.safeAreaInsets.bottom ?? 0
    }

    var topNavBarViewControllers: [UIViewController]? {
        return UIApplication.topViewController()?.navigationController?.viewControllers
    }

    class func topViewController(controller: UIViewController? = AppDelegate.shared.appCoordinator?.window.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabBarController = controller as? UITabBarController {
            return topViewController(controller: tabBarController.selectedViewController)
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }

    class func dismissOpenAlerts(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) {
        if let alertController = UIApplication.topViewController() as? UIAlertController {
            alertController.dismiss(animated: false, completion: nil)
        }
    }
}

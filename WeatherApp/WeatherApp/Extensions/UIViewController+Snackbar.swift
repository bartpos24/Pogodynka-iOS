//
//  UIViewController+Snackbar.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 03/06/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation
import UIKit
import TTGSnackbar

extension UIViewController {
    func showSnackbar(message: String,
                      bottomMargin: CGFloat,
                      actionIcon: UIImage? = UIImage(named: "close"),
                      duration: TTGSnackbarDuration = .middle,
                      actionBlock: ((_ snackbar: TTGSnackbar) -> Void)? = nil) {
        let snackbar = TTGSnackbar()
        snackbar.cornerRadius = 21.0
        snackbar.message = message
        snackbar.duration = duration
        snackbar.messageTextFont = .regularFont(size: 14)
        snackbar.bottomMargin = bottomMargin
        snackbar.leftMargin = 16.0
        snackbar.rightMargin = 16.0
        snackbar.contentInset = UIEdgeInsets(top: 12, left: 16, bottom: 13.5, right: 12)
        snackbar.backgroundColor = .black
        snackbar.actionBlock = actionBlock ?? { snackbar in
            snackbar.dismiss()
        }
        snackbar.separateViewBackgroundColor = .white
        snackbar.actionIcon = actionIcon
        NSLayoutConstraint.activate([
            snackbar.heightAnchor.constraint(greaterThanOrEqualToConstant: 60.0)
        ])
        snackbar.show()
    }
}

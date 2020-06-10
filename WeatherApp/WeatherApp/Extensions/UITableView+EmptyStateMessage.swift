//
//  UITableView+EmptyStateMessage.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 30/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func emptyState(message: String) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.bounds.size.width, height: self.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .regularFont(size: 14.0)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
    }
}

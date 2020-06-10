//
//  UIFont+CustomFont.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation
import UIKit

public extension UIFont {
    class func regularFont(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Verdana", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}

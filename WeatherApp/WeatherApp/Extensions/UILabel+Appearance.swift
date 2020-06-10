//
//  UILabel+Appearance.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    convenience init(font: UIFont, textColor: UIColor, text: String? = nil) {
        self.init()
        self.setAppearance(font, textColor: textColor, text: text)
    }

    func setAppearance(_ font: UIFont, textColor: UIColor? = .black, text: String? = nil, defaultText: String? = "", lineHeight: CGFloat? = nil) {
        self.font = font
        self.textColor = textColor
        let labelText = (text == nil || text?.isEmpty ?? false) ? defaultText : text
        if let lineHeight = lineHeight {
            let attributedString = NSMutableAttributedString(string: labelText ?? "")
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = lineHeight
            paragraphStyle.maximumLineHeight = lineHeight
            let range = NSRange(location: 0, length: attributedString.length)
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range )
            self.attributedText = attributedString
        } else {
            self.text = labelText
        }
    }
}

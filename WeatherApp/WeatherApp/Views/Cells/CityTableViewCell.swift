//
//  CityTableViewCell.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation
import UIKit

class CityTableViewCell: UITableViewCell {
    @IBOutlet private var cellTitle: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var customBackgroundView: UIView!

    static let identifier = "CityTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()

        cellTitle.setAppearance(.regularFont(size: 14.0), textColor: .gray, text: "City:")
        titleLabel.setAppearance(.regularFont(size: 18.0))

        customBackgroundView.layer.cornerRadius = 15.0
        backgroundColor = .clear
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }

    func setup(with city: City) {
        titleLabel.text = city.name
    }

    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

//
//  HomeTableViewCell.swift
//  WeatherApp
//
//  Created by Bartek Poskart on 29/05/2020.
//  Copyright © 2020 Bartek Poskart. All rights reserved.
//

import Foundation
import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet private var cellTitle: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var customBackgroundView: UIView!

    static let identifier = "HomeTableViewCell"

    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        cellTitle.setAppearance(.regularFont(size: 14.0), textColor: .gray, text: "Country:")
        titleLabel.setAppearance(.regularFont(size: 18.0))
        
        customBackgroundView.layer.cornerRadius = 15.0
        backgroundColor = .clear
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }

    func setup(with country: Country) {
        titleLabel.text = country.country
    }
}

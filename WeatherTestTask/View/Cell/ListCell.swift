//
//  ListCell.swift
//  WeatherTestTask
//
//  Created by Vladimir Sekerko on 12.10.2022.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var nameCityLabel: UILabel!
    @IBOutlet weak var conditionCityLabel: UILabel!
    @IBOutlet weak var tempCityLabel: UILabel!

    func configure(withWeather weather: Weather) {
        nameCityLabel.text = weather.name
        conditionCityLabel.text = weather.coditionString
        tempCityLabel.text = weather.temperatureString
    }
}

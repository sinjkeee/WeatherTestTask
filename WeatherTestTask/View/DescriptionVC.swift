//
//  DescriptionVC.swift
//  WeatherTestTask
//
//  Created by Vladimir Sekerko on 10.10.2022.
//

import UIKit
import SwiftSVG

class DescriptionVC: UIViewController {
    
    @IBOutlet weak var nameCityLabel: UILabel!
    @IBOutlet weak var imageWeatherView: UIView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    
    var weatherModel: Weather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLabels()
    }
    
    private func updateLabels() {
        guard let weatherModel = weatherModel else { return }
        
        nameCityLabel.text = weatherModel.name
        conditionLabel.text = weatherModel.coditionString
        temperatureLabel.text = weatherModel.temperatureString
        pressureLabel.text = String(describing: weatherModel.presureMm)
        windSpeedLabel.text = String(describing: weatherModel.windSpeed)
        minTemperatureLabel.text = String(describing: weatherModel.tempMin)
        maxTemperatureLabel.text = String(describing: weatherModel.tempMax)
        
        let urlString = "https://yastatic.net/weather/i/icons/funky/dark/\(String(describing: weatherModel.conditionCode)).svg"
        guard let url = URL(string: urlString) else { return }
        
        let weatherImage = UIView(SVGURL: url) { [weak self] (image) in
            guard let self = self else { return }
            image.resizeToFit(self.imageWeatherView.bounds)
        }
        
        imageWeatherView.addSubview(weatherImage)
    }
}

//
//  GetCitiesWeather.swift
//  WeatherTestTask
//
//  Created by Vladimir Sekerko on 11.10.2022.
//

import Foundation
import CoreLocation

extension ListTableVC {

    func getCoordinateFrom(city: String, completionHandler: @escaping (_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> Void) {
        CLGeocoder().geocodeAddressString(city) { (placemark, error) in
            guard let coordinate = placemark?.first?.location?.coordinate else { return }
            completionHandler(coordinate, error)
        }
    }

    func getCityWeather(cities: [String], completionHandler: @escaping (Int, Weather) -> Void) {
        for (index, name) in cities.enumerated() {
            getCoordinateFrom(city: name) { (coordinate, error) in
                guard let coordinate = coordinate, error == nil else { return }
                NetworkWeatherManager.shared.fetchWeather(latitude: coordinate.latitude, longitude: coordinate.longitude) { weather in
                    completionHandler(index, weather)
                }
            }
        }
    }
}


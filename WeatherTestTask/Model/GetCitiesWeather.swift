//
//  GetCitiesWeather.swift
//  WeatherTestTask
//
//  Created by Vladimir Sekerko on 11.10.2022.
//

import Foundation
import CoreLocation

func getCoordinateFrom(city: String, completionHandler: @escaping (_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> Void) {
    CLGeocoder().geocodeAddressString(city) { (placemark, error) in
        guard let coordinate = placemark?.first?.location?.coordinate else { return }
        completionHandler(coordinate, error)
    }
}


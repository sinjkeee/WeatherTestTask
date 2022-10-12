//
//  NetworkWeatherManager.swift
//  WeatherTestTask
//
//  Created by Vladimir Sekerko on 10.10.2022.
//

import Foundation

class NetworkWeatherManager {
    
    static let shared = NetworkWeatherManager()
    private init() {}
    
    private var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "apiKey") as? String else { return "" }
        return key
    }
    
    func fetchWeather(latitude: Double, longitude: Double, completionHandler: @escaping (_ weather: Weather) -> Void) {
        let urlString = "https://api.weather.yandex.ru/v2/forecast?lat=\(latitude)&lon=\(longitude)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-Yandex-API-Key")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            guard let data = data else {
                print(String(describing: error))
                return
            }
            //print(String(data: data, encoding: .utf8)!)
            if let weather = self.parseJSON(withData: data) {
                completionHandler(weather)
            }
        }
        task.resume()
    }
    
    private func parseJSON(withData data: Data) -> Weather? {
        let decoder = JSONDecoder()
        do {
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            guard let weather = Weather(weatherData: weatherData) else { return nil }
            return weather
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
}

//
//  WeatherManager.swift
//  NewsApp
//
//  Created by Dilip on 2024-08-06.
//


import Foundation
import CoreLocation

struct WeatherResponse: Codable {
    let main: Main
    let weather: [Weather]
    let name: String

    struct Main: Codable {
        let temp: Double
    }

    struct Weather: Codable {
        let description: String
    }
}

class WeatherManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let apiKey = "e0e474f8371d0c089d99da6a85a699fc" // Replace with your OpenWeatherMap API key
    private var locationManager = CLLocationManager()
    @Published var weather: WeatherResponse?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func fetchWeather(for location: CLLocation) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=45.5532077872&lon=-73.667673996&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.weather = decodedResponse
                    }
                } catch {
                    print("Failed to decode weather data: \(error)")
                }
            }
        }.resume()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            fetchWeather(for: location)
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error)")
    }
}

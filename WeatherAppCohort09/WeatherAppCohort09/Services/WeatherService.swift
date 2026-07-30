//
//  WeatherService.swift
//  WeatherAppCohort09
//
//  Created by Lenin Baku Cortez Hernandez on 25/07/26.
//

import Foundation

enum WeatherServiceError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
}

class WeatherService {

    func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherResponse, WeatherServiceError>) -> Void) {

        var components = URLComponents(string: "https://api.open-meteo.com/v1/forecast")
        components?.queryItems = [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "current", value: "temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code")
        ]

        guard let url = components?.url else {
            completion(.failure(.invalidURL))
            return
        }

        print("Weather URL: \(url.absoluteString)")

        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(.failure(.requestFailed))
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Weather status code: \(httpResponse.statusCode)")
                DispatchQueue.main.async {
                    completion(.failure(.requestFailed))
                }
                return
            }

            guard let data else {
                DispatchQueue.main.async {
                    completion(.failure(.requestFailed))
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Decoding error, raw JSON: \(jsonString.prefix(300))")
                }
                DispatchQueue.main.async {
                    completion(.failure(.decodingFailed))
                }
            }
        }.resume()
    }
}

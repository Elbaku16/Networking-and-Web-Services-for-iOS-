//
//  GeocodingService.swift
//  WeatherAppCohort09
//
//  Created by Lenin Baku Cortez Hernandez on 25/07/26.
//

import Foundation

enum GeocodingError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
    case noResults
}

class GeocodingService {

    func searchLocation(query: String, completion: @escaping (Result<Location, GeocodingError>) -> Void) {

        var components = URLComponents(string: "https://geocoding-api.open-meteo.com/v1/search")
        components?.queryItems = [
            URLQueryItem(name: "name", value: query),
            URLQueryItem(name: "count", value: "1"),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "format", value: "json")
        ]

        guard let url = components?.url else {
            completion(.failure(.invalidURL))
            return
        }

        print("Geocoding URL: \(url.absoluteString)")

        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(.failure(.requestFailed))
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Geocoding status code: \(httpResponse.statusCode)")
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
                let decoded = try JSONDecoder().decode(GeocodingResponse.self, from: data)

                guard let firstResult = decoded.results?.first else {
                    DispatchQueue.main.async {
                        completion(.failure(.noResults))
                    }
                    return
                }

                DispatchQueue.main.async {
                    completion(.success(firstResult))
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

//
//  WeatherResponse.swift
//  WeatherAppCohort09
//
//  Created by Lenin Baku Cortez Hernandez on 25/07/26.
//

import Foundation

struct WeatherResponse: Codable {
    let current: CurrentWeather
}

struct CurrentWeather: Codable {
    let temperature2m: Double
    let relativeHumidity2m: Double
    let windSpeed10m: Double
    let weatherCode: Int

    enum CodingKeys: String, CodingKey {
        case temperature2m = "temperature_2m"
        case relativeHumidity2m = "relative_humidity_2m"
        case windSpeed10m = "wind_speed_10m"
        case weatherCode = "weather_code"
    }
}

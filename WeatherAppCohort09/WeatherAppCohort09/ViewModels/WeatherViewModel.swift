//
//  WeatherViewModel.swift
//  WeatherAppCohort09
//
//  Created by Lenin Baku Cortez Hernandez on 25/07/26.
//

import Foundation
import Combine

enum WeatherViewState {
    case idle
    case loading
    case success
    case failed
}

class WeatherViewModel: ObservableObject {

    @Published var searchText: String = ""
    @Published var viewState: WeatherViewState = .idle
    @Published var errorMessage: String = ""

    @Published var locationName: String = ""
    @Published var temperature: Double = 0.0
    @Published var humidity: Double = 0.0
    @Published var windSpeed: Double = 0.0
    @Published var weatherCondition: String = ""

    private let geocodingService: GeocodingService = GeocodingService()
    private let weatherService: WeatherService = WeatherService()

    func search() {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            errorMessage = "Please enter a city name."
            viewState = .failed
            return
        }

        viewState = .loading
        errorMessage = ""

        geocodingService.searchLocation(query: trimmed) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let location):
                self.locationName = self.formatLocationName(location)
                self.fetchWeather(latitude: location.latitude, longitude: location.longitude)

            case .failure(let error):
                self.viewState = .failed
                self.errorMessage = self.message(for: error)
            }
        }
    }

    private func fetchWeather(latitude: Double, longitude: Double) {
        weatherService.fetchWeather(latitude: latitude, longitude: longitude) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let weather):
                self.temperature = weather.current.temperature2m
                self.humidity = weather.current.relativeHumidity2m
                self.windSpeed = weather.current.windSpeed10m
                self.weatherCondition = self.description(forCode: weather.current.weatherCode)
                self.viewState = .success

            case .failure(let error):
                self.viewState = .failed
                self.errorMessage = self.message(for: error)
            }
        }
    }

    private func formatLocationName(_ location: Location) -> String {
        var parts = [location.name]
        if let admin1 = location.admin1 { parts.append(admin1) }
        if let country = location.country { parts.append(country) }
        return parts.joined(separator: ", ")
    }

    private func message(for error: GeocodingError) -> String {
        switch error {
        case .invalidURL: return "Invalid search request."
        case .requestFailed: return "Network error. Please check your connection."
        case .decodingFailed: return "Could not read location data."
        case .noResults: return "No location found for that search."
        }
    }

    private func message(for error: WeatherServiceError) -> String {
        switch error {
        case .invalidURL: return "Invalid weather request."
        case .requestFailed: return "Network error while fetching weather."
        case .decodingFailed: return "Could not read weather data."
        }
    }

    // Open-Meteo weather codes -> simple text (WMO code table, simplified)
    private func description(forCode code: Int) -> String {
        switch code {
        case 0: return "Clear sky"
        case 1, 2, 3: return "Partly cloudy"
        case 45, 48: return "Fog"
        case 51, 53, 55: return "Drizzle"
        case 61, 63, 65: return "Rain"
        case 71, 73, 75: return "Snow"
        case 80, 81, 82: return "Rain showers"
        case 95, 96, 99: return "Thunderstorm"
        default: return "Unknown"
        }
    }
}

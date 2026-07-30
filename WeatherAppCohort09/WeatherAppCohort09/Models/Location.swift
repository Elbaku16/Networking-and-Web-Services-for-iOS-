//
//  Location.swift
//  WeatherAppCohort09
//
//  Created by Lenin Baku Cortez Hernandez on 25/07/26.
//

import Foundation

// Geocoding API responsE
struct GeocodingResponse: Codable {
    let results: [Location]?
}

struct Location: Codable, Identifiable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String?
    let admin1: String?
}

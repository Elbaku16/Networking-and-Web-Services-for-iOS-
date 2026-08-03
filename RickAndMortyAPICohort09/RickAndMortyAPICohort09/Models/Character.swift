//
//  Character.swift
//  RickAndMortyCohort09
//
//  Created by Lenin Baku Cortez Hernandez on 29/07/26.
//

import Foundation

// Matches the /api/character list response
struct CharacterResponse: Codable {
    let results: [RMCharacter]
}

struct RMCharacter: Codable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let image: String
    let origin: Origin

    struct Origin: Codable {
        let name: String
    }
}

//
//  CharacterViewModel.swift
//  RickAndMortyCohort09
//
//  Created by Lenin Baku Cortez Hernandez on 29/07/26.
//

import Foundation
import Combine

class CharacterViewModel: ObservableObject {

    @Published var characters: [RMCharacter] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""

    private let characterService: CharacterService = CharacterService()

    func fetchCharacters() {
        isLoading = true
        errorMessage = ""

        characterService.fetchCharacters { [weak self] result in
            guard let self else { return }
            self.isLoading = false

            switch result {
            case .success(let characters):
                self.characters = characters
            case .failure(let error):
                self.errorMessage = self.message(for: error)
            }
        }
    }

    private func message(for error: CharacterServiceError) -> String {
        switch error {
        case .invalidURL: return "Invalid URL."
        case .invalidResponse: return "The server did not respond correctly."
        case .decodingError: return "Could not read character data."
        case .unknown: return "Something went wrong. Please try again."
        }
    }
}

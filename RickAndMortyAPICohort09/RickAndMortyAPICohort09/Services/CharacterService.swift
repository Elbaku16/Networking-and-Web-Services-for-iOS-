//
//  CharacterService.swift
//  RickAndMortyCohort09
//
//  Created by Lenin Baku Cortez Hernandez on 29/07/26.
//

import Foundation

enum CharacterServiceError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case unknown
}

class CharacterService {

    func fetchCharacters(completion: @escaping (Result<[RMCharacter], CharacterServiceError>) -> Void) {

        guard let url = URL(string: "https://rickandmortyapi.com/api/character") else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in

            if error != nil {
                DispatchQueue.main.async {
                    completion(.failure(.unknown))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }

            guard let data else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(CharacterResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded.results))
                }
            } catch {
                print("Decoding error: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
            }

        }.resume()
    }
}

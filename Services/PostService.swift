//
//  PostService.swift
//  PostsApp
//
//  Created by Lenin Baku Cortez Hernandez on 25/07/26.
//

import Foundation

enum PostServiceError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
}

class PostService {

    private let postsURL = "https://jsonplaceholder.typicode.com/posts"

    func fetchPosts(completion: @escaping (Result<[Post], PostServiceError>) -> Void) {
        guard let url = URL(string: postsURL) else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
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
                let posts = try JSONDecoder().decode([Post].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(posts))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingFailed))
                }
            }
        }.resume()
    }
}

//
//  PostListViewModel.swift
//  PostsApp
//
//  Created by Lenin Baku Cortez Hernandez on 25/07/26.
//

import Foundation
import Combine

class PostListViewModel: ObservableObject {

    @Published var posts: [Post] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""

    private let postService: PostService = PostService()

    func fetchPosts() {
        isLoading = true
        errorMessage = ""

        postService.fetchPosts { [weak self] result in
            guard let self else { return }
            self.isLoading = false

            switch result {
            case .success(let posts):
                self.posts = posts
            case .failure:
                self.errorMessage = "Failed to load posts. Please try again."
            }
        }
    }
}

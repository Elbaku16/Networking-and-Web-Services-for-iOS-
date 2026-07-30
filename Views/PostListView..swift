//
//  PostListView.swift
//  PostsApp
//
//  Created by Lenin Baku Cortez Hernandez on 25/07/26.
//

import SwiftUI

struct PostListView: View {
    @StateObject var viewModel: PostListViewModel = PostListViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading posts...")
                } else if !viewModel.errorMessage.isEmpty {
                    VStack(spacing: 12) {
                        Text(viewModel.errorMessage)
                            .foregroundStyle(.red)
                        Button("Retry") {
                            viewModel.fetchPosts()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    List(viewModel.posts) { post in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(post.title)
                                .font(.headline)
                            Text(post.body)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Posts")
            .onAppear {
                if viewModel.posts.isEmpty {
                    viewModel.fetchPosts()
                }
            }
        }
    }
}

#Preview {
    PostListView()
}

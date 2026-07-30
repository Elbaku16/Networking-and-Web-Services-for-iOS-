//
//  Post.swift
//  PostsApp
//
//  Created by Lenin Baku Cortez Hernandez on 25/07/26.
//

import Foundation

struct Post: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

//
//  MoviesResponse.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 02.05.2022..
//

struct MovieListResponse: Decodable, Equatable {
    enum CodingKeys: String, CodingKey {
        case movies = "results"
        case page
        case totalPages = "total_pages"
    }
    var movies: [MovieRemote]
    var page: Int
    var totalPages: Int
}

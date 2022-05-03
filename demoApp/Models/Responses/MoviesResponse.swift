//
//  MoviesResponse.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 02.05.2022..
//

import Foundation

struct MovieListResponse: Decodable, Equatable {
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }

    var movies: [Movie]

    init() {
        movies = []
        for index in 0...5 {
            let movie = Movie(with: index)
            movies.append(movie)
        }
    }
}

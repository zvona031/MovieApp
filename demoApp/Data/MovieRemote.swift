//
//  Movie.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 27.04.2022..
//

struct MovieRemote: Codable, Hashable {
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case originalTitle = "original_title"
        case voteAverage = "vote_average"
        case overview
    }

    let id: Int
    let posterPath: String?
    let originalTitle: String
    let voteAverage: Double
    let overview: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension MovieRemote {
    func mapToMoviePresent(with isFavorite: Bool) -> MoviePresent {
        return MoviePresent(with: self, isFavorite: isFavorite)
    }
}

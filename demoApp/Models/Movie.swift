//
//  Movie.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 27.04.2022..
//

import RealmSwift

struct Movie: Codable, Hashable {
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case originalTitle = "original_title"
        case voteAverage = "vote_average"
        case overview
    }

    let id: Int
    let posterPath: String
    let originalTitle: String
    let voteAverage: Double
    let overview: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

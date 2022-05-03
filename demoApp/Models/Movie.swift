//
//  Movie.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 27.04.2022..
//

import RealmSwift

struct Movie: Codable, Hashable {
    let id: Int
    let posterPath: String
    let originalTitle: String
    let voteAverage: Double
    let overview: String
    let isFavorite: Bool

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    init(with id: Int) {
        self.id = id
        self.posterPath = ""
        self.originalTitle = ""
        self.voteAverage = 0.0
        self.overview = ""
        self.isFavorite = id % 2 == 0
    }
}

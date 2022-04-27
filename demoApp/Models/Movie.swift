//
//  Movie.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 27.04.2022..
//

import RealmSwift

class Movie: Object {
    @Persisted var id: Int
    @Persisted var posterPath: String
    @Persisted var originalTitle: String
    @Persisted var voteAverage: Double
    @Persisted var overview: String
    @Persisted var isFavorite: Bool
}

//
//  MoviePresent.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 18.05.2022..
//

import Foundation

class MoviePresent: Hashable {
    var id: Int = 0
    var posterPath: String = ""
    var originalTitle: String = ""
    var voteAverage: Double = 0.0
    var overview: String = ""
    var isFavorite: Bool = false

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: MoviePresent, rhs: MoviePresent) -> Bool {
        return lhs.id == rhs.id
    }

    init(with movie: MovieRemote, isFavorite: Bool) {
        self.id = movie.id
        self.posterPath = movie.posterPath
        self.originalTitle = movie.originalTitle
        self.voteAverage = movie.voteAverage
        self.overview = movie.overview
        self.isFavorite = isFavorite
    }

    init(with movie: MovieLocal) {
        self.id = movie.id
        self.posterPath = movie.posterPath
        self.originalTitle = movie.originalTitle
        self.voteAverage = movie.voteAverage
        self.overview = movie.overview
        self.isFavorite = true
    }

}

extension MoviePresent {
    func mapToLocal() -> MovieLocal {
        return MovieLocal(with: self)
    }

    func setIsFavorite(with isFavorite: Bool) {
        self.isFavorite = isFavorite
    }

    func toggleIsFavorite() {
        self.isFavorite.toggle()
    }
}

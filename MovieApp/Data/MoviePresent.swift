//
//  MoviePresent.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 18.05.2022..
//

import Foundation

struct MoviePresent: Hashable {
    var id: Int
    var posterPath: String?
    var originalTitle: String
    var voteAverage: Double
    var overview: String
    var isFavorite: Bool

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(isFavorite)
    }

    static func == (lhs: MoviePresent, rhs: MoviePresent) -> Bool {
        return lhs.id == rhs.id
    }

    init(id: Int, posterPath: String?, originalTitle: String, voteAverage: Double, overview: String, isFavorite: Bool) {
        self.id = id
        self.posterPath = posterPath
        self.originalTitle = originalTitle
        self.voteAverage = voteAverage
        self.overview = overview
        self.isFavorite = isFavorite
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

    mutating func setIsFavorite(with isFavorite: Bool) {
        self.isFavorite = isFavorite
    }

    mutating func toggleIsFavorite() {
        self.isFavorite.toggle()
    }

    var moviePosterUrl: URL? {
        if let posterPath = posterPath {
            return URL(string: "https://image.tmdb.org/t/p/w400" + posterPath)
        } else {
            return nil
        }
    }
}

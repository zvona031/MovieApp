//
//  MovieLocal.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 18.05.2022..
//

import RealmSwift

class MovieLocal: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var posterPath: String?
    @Persisted var originalTitle: String
    @Persisted var voteAverage: Double
    @Persisted var overview: String

    convenience init(with moviePresent: MoviePresent) {
        self.init()
        id = moviePresent.id
        posterPath = moviePresent.posterPath
        originalTitle = moviePresent.originalTitle
        voteAverage = moviePresent.voteAverage
        overview = moviePresent.overview
    }
}

extension MovieLocal {
    final func mapToMoviePresent() -> MoviePresent {
        return MoviePresent(with: self)
    }
}

//
//  MoviePresent.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 18.05.2022..
//

import Foundation

struct MoviePresent: Hashable {

    let id: Int
    let posterPath: String
    let originalTitle: String
    let voteAverage: Double
    let overview: String
    var isFavorite: Bool

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension MoviePresent {

    func mapToLocal() -> MovieLocal {
        return MovieLocal(with: self)
    }

    mutating func setIsFavorite(with isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
}

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
    let isFavorite: Bool

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension MoviePresent {

    func mapToLocal() -> MovieLocal {
        return MovieLocal(with: self)
    }
}

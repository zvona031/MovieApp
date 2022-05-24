//
//  MovieDetailsViewModel.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 17.05.2022..
//

import Resolver
import Foundation

class MovieDetailsViewModel {
    var movie: MoviePresent

    init(for movie: MoviePresent) {
        self.movie = movie
    }

    var coverUrl: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w400" + movie.posterPath)
    }
}

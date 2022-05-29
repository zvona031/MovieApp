//
//  MovieDetailsViewModel.swift
//  MovieApp
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

    var moviePosterUrl: URL? {
        return movie.moviePosterUrl
    }
}

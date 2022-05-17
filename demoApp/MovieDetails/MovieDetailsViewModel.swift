//
//  MovieDetailsViewModel.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 17.05.2022..
//

import Resolver

class MovieDetailsViewModel {
    var movie: Movie

    init(for movie: Movie) {
        self.movie = movie
    }
}

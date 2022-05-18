//
//  MovieDetailsViewModel.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 17.05.2022..
//

import Resolver

class MovieDetailsViewModel {
    var movie: MoviePresent

    init(for movie: MoviePresent) {
        self.movie = movie
    }
}

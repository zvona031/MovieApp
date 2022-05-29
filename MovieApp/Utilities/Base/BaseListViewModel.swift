//
//  BaseViewModel.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 23.05.2022..
//

import Resolver
import Combine
import Foundation

class BaseViewModel {
    var itemType: TabBarItemType
    @Injected private(set) var moviesService: MoviesRepository
    @Published var movies: [MoviePresent] = []

    init(withType itemType: TabBarItemType) {
        self.itemType = itemType
    }

    func getMovies() {
        switch itemType {
        case .upcoming:
            getUpcomingMovies()
        case .popular:
            getPopularMovies()
        case .favorite:
            getFavoriteMovies()
        case .search:
            return
        }
    }

    internal func getPopularMovies() {
        fatalError("Must Override")
    }

    func getFavoriteMovies() {
        fatalError("Must Override")
    }

    func getUpcomingMovies() {
        fatalError("Must Override")
    }

    func searchForMovies(with searchText: String) {
        fatalError("Must Override")
    }

    func favoriteClicked(with movie: MoviePresent) {
        NotificationCenter.default.post(name: .favoriteClicked, object: nil, userInfo: ["movie": movie, "itemType": itemType])
        if movie.isFavorite {
            moviesService.saveFavoriteMovie(movie: movie.mapToLocal())
        } else {
            moviesService.removeFavoriteMovie(movie: movie.mapToLocal())
        }
    }
}

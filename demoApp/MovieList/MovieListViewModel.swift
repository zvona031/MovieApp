//
//  MovieListViewModel.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 28.04.2022..
//

import Resolver
import Combine

final class MovieListViewModel {
    let itemType: TabBarItemType
    @Injected private var moviesService: MoviesRemoteRepository
    @Published private(set) var movies: [Movie] = []

    init(withType itemType: TabBarItemType) {
        self.itemType = itemType
    }

    func getMovies() {
        Just<Void>(())
            .flatMap { [unowned self] in
                moviesService.getPopularMovies().map { movieListResponse in
                    movieListResponse.movies
                }.catch { error in
                    Just<[Movie]>([])
                }
            }
            .assign(to: &$movies)
        // sta sad s ovim koju kitu
    }
}


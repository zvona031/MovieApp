//
//  MovieListViewModel.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 28.04.2022..
//

import Resolver
import Combine

final class MovieListViewModel {
    @Injected private var moviesService: MoviesRepository
    let itemType: TabBarItemType
    @Published private(set) var movies: [MoviePresent] = []

    init(withType itemType: TabBarItemType) {
        self.itemType = itemType
    }

    func getMovies() {
        Just<Void>(())
            .flatMap { [unowned self] in
                moviesService.getPopularMovies()
                    .map { movieListResponse in
                        movieListResponse.movies.map { movieRemote in
                            movieRemote.mapToMoviePresent()
                        }
                    }
                    .catch { _ in
                        Just<[MoviePresent]>([])
                    }
            }
            .assign(to: &$movies)
    }

    func favoriteClicked(with movie: MoviePresent) {
        moviesService.saveFavoriteMovie(movie: movie.mapToLocal())
    }
}

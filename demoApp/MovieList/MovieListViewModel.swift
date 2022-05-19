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
        switch itemType {
        case .latest:
            getPopularMovies()
        case .popular:
            getPopularMovies()
        case .favorite:
            getFavoriteMovies()
        case .search:
            break
        }
    }

    private func getPopularMovies() {
        Just<Void>(())
            .flatMap { [unowned self] in
                moviesService.getPopularMovies()
                    .map { movieListResponse in
                        movieListResponse.movies.map { movieRemote in
                            movieRemote.mapToMoviePresent(with: self.moviesService.isMovieFavorite(with: movieRemote.id))
                        }
                    }
                    .catch { _ in
                        Just<[MoviePresent]>([])
                    }
            }
            .assign(to: &$movies)
    }

    private func getFavoriteMovies() {
        movies = moviesService.getFavoriteMovies().map({ movieLocal in
            movieLocal.mapToMoviePresent()
        })
    }

    private func getLatestMovies() {
        Just<Void>(())
            .flatMap { [unowned self] in
                moviesService.getPopularMovies()
                    .map { movieListResponse in
                        movieListResponse.movies.map { movieRemote in
                            movieRemote.mapToMoviePresent(with: self.moviesService.isMovieFavorite(with: movieRemote.id))
                        }
                    }
                    .catch { _ in
                        Just<[MoviePresent]>([])
                    }
            }
            .assign(to: &$movies)
    }

    func favoriteClicked(with movie: MoviePresent) {
        if movie.isFavorite {
            moviesService.removeFavoriteMovie(movie: movie.mapToLocal())
        } else {
            moviesService.saveFavoriteMovie(movie: movie.mapToLocal())
        }
    }
}

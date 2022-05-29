//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 28.04.2022..
//

import Resolver
import Combine
import Foundation

final class MovieListViewModel: BaseViewModel {
    override func getPopularMovies() {
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

    override func getFavoriteMovies() {
        movies = moviesService.getFavoriteMovies()
            .map { movieLocal in
            movieLocal.mapToMoviePresent()
            }
            .reversed()
    }

    override func getUpcomingMovies() {
        Just<Void>(())
            .flatMap { [unowned self] in
                moviesService.getUpcomingMovies()
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
}

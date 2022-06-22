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
                moviesRepository.getPopularMovies(with: MoviePaginationRequest(page: currentPage))
                    .map { movieListResponse in
                        self.currentPage = movieListResponse.page
                        self.totalPages = movieListResponse.totalPages
                        if self.currentPage == 1 { self.movies.removeAll() }
                        return movieListResponse.movies.map { movieRemote in
                            movieRemote.mapToMoviePresent(with: self.moviesRepository.isMovieFavorite(with: movieRemote.id))
                        }
                    }
                    .catch { _ in
                        Just<[MoviePresent]>([])
                    }
            }
            .sink { newMovies in
                self.movies.append(contentsOf: newMovies)
                self.fetchingInProgress = false
            }
            .store(in: &subscriptions)
    }

    override func getFavoriteMovies() {
        movies = moviesRepository.getFavoriteMovies()
            .map { movieLocal in
            movieLocal.mapToMoviePresent()
            }
            .reversed()
    }

    override func getUpcomingMovies() {
        Just<Void>(())
            .flatMap { [unowned self] in
                moviesRepository.getUpcomingMovies(with: MoviePaginationRequest(page: currentPage))
                    .map { movieListResponse in
                        self.currentPage = movieListResponse.page
                        self.totalPages = movieListResponse.totalPages
                        if self.currentPage == 1 { self.movies.removeAll() }
                        return movieListResponse.movies.map { movieRemote in
                            movieRemote.mapToMoviePresent(with: self.moviesRepository.isMovieFavorite(with: movieRemote.id))
                        }
                    }
                    .catch { _ in
                        Just<[MoviePresent]>([])
                    }
            }
            .sink { newMovies in
                self.movies.append(contentsOf: newMovies)
                self.fetchingInProgress = false
            }
            .store(in: &subscriptions)
    }
}

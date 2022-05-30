//
//  MovieSearchViewModel.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 23.05.2022..
//

import Resolver
import Combine
import Foundation

class MovieSearchViewModel: BaseViewModel {
    override func searchForMovies(with searchText: String) {
        Just<Void>(())
            .flatMap { [unowned self] in
                moviesRepository.searchForMovies(with: MovieSearchRequest(query: searchText))
                    .map { movieListResponse in
                        movieListResponse.movies.map { movieRemote in
                            movieRemote.mapToMoviePresent(with: self.moviesRepository.isMovieFavorite(with: movieRemote.id))
                        }
                    }
                    .catch { _ in
                        Just<[MoviePresent]>([])
                    }
            }
            .assign(to: &$movies)
    }
}

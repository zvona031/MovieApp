//
//  MoviesLocalRepository.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 18.05.2022..
//

import Foundation
import Combine
import Resolver

protocol MoviesLocalRepository {
    func getFavoriteMovies() -> AnyPublisher<MovieListResponse, Error>
}

final class MoviesLocalRepositoryImpl: MoviesLocalRepository {
    @Injected private var networkClient: Networking

    func getFavoriteMovies() -> AnyPublisher<MovieListResponse, Error> {
        networkClient.request(endpoint: Endpoint.getLatestMovies(queryRequest))
    }
}

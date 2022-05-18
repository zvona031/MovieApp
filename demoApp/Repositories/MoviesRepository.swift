//
//  MoviesService.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 02.05.2022..
//

import Combine
import Resolver

protocol MoviesRepository {
    func getLatestMovies(with queryRequest: QueryRequestable) -> AnyPublisher<MovieListResponse, Error>
    func getPopularMovies() -> AnyPublisher<MovieListResponse, Error>
    func saveFavoriteMovie(movie: MovieLocal)
    func removeFavoriteMovie(movie: MovieLocal)
    
}

final class MoviesRepositoryImpl: MoviesRepository {
    @Injected private var networkService: Networking
    @Injected private var databaseService: DatabaseService

    func getLatestMovies(with queryRequest: QueryRequestable) -> AnyPublisher<MovieListResponse, Error> {
        networkService.request(endpoint: Endpoint.getLatestMovies(queryRequest))
    }

    func getPopularMovies() -> AnyPublisher<MovieListResponse, Error> {
        networkService.request(endpoint: Endpoint.getPopularMovies)
    }

    func saveFavoriteMovie(movie: MovieLocal) {
        databaseService.saveFavoriteMovie(with: movie)
    }

    func removeFavoriteMovie(movie: MovieLocal) {
        databaseService.removeFavoriteMovie(with: movie)
    }
}

// MARK: - Endpoints
extension MoviesRepositoryImpl {
    enum Endpoint {
        case getLatestMovies(QueryRequestable)
        case getPopularMovies
    }
}

extension MoviesRepositoryImpl.Endpoint: APIConfigurable {
    var path: String {
        switch self {
        case .getLatestMovies: return "/movie/latest"
        case .getPopularMovies: return "/movie/popular"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getLatestMovies: return .get
        case .getPopularMovies: return .get
        }
    }

    var headers: [String: String]? {
        switch self {
        case .getLatestMovies: return nil
        case .getPopularMovies: return nil
        }
    }

    var queryRequestable: QueryRequestable? {
        switch self {
        case .getLatestMovies(let queryRequestable): return queryRequestable
        case .getPopularMovies: return nil
        }
    }

    var bodyRequestable: BodyRequestable? {
        switch self {
        case .getLatestMovies: return nil
        case .getPopularMovies: return nil
        }
    }
}

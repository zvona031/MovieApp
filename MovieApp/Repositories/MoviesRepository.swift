//
//  MoviesService.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 02.05.2022..
//

import Combine
import Resolver
import RealmSwift

protocol MoviesRepository {
    func getUpcomingMovies() -> AnyPublisher<MovieListResponse, Error>
    func getPopularMovies() -> AnyPublisher<MovieListResponse, Error>
    func getFavoriteMovies() -> Results<MovieLocal>
    func searchForMovies(with searchQuery: QueryRequestable) -> AnyPublisher<MovieListResponse, Error>
    func isMovieFavorite(with id: Int) -> Bool
    func saveFavoriteMovie(movie: MovieLocal)
    func removeFavoriteMovie(movie: MovieLocal)
}

final class MoviesRepositoryImpl: MoviesRepository {
    @Injected private var networkService: Networking
    @Injected private var databaseService: DatabaseService

    func getUpcomingMovies() -> AnyPublisher<MovieListResponse, Error> {
        networkService.request(endpoint: Endpoint.getUpcomingMovies)
    }

    func getPopularMovies() -> AnyPublisher<MovieListResponse, Error> {
        networkService.request(endpoint: Endpoint.getPopularMovies)
    }

    func getFavoriteMovies() -> Results<MovieLocal> {
        databaseService.getFavoriteMovies()
    }

    func searchForMovies(with searchQuery: QueryRequestable) -> AnyPublisher<MovieListResponse, Error> {
        networkService.request(endpoint: Endpoint.searchForMovies(searchQuery))
    }

    func saveFavoriteMovie(movie: MovieLocal) {
        databaseService.saveFavoriteMovie(with: movie)
    }

    func removeFavoriteMovie(movie: MovieLocal) {
        databaseService.removeFavoriteMovie(with: movie)
    }

    func isMovieFavorite(with id: Int) -> Bool {
        databaseService.isMovieFavorite(with: id)
    }
}

// MARK: - Endpoints
extension MoviesRepositoryImpl {
    enum Endpoint {
        case getUpcomingMovies
        case getPopularMovies
        case searchForMovies(QueryRequestable)
    }
}

extension MoviesRepositoryImpl.Endpoint: APIConfigurable {
    var path: String {
        switch self {
        case .getUpcomingMovies: return "movie/upcoming"
        case .getPopularMovies: return "movie/popular"
        case .searchForMovies: return "search/movie"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getUpcomingMovies: return .get
        case .getPopularMovies: return .get
        case .searchForMovies: return .get
        }
    }

    var headers: [String: String]? {
        switch self {
        case .getUpcomingMovies: return nil
        case .getPopularMovies: return nil
        case .searchForMovies: return nil
        }
    }

    var queryRequestable: QueryRequestable? {
        switch self {
        case .getUpcomingMovies: return nil
        case .getPopularMovies: return nil
        case .searchForMovies(let searchQuery): return searchQuery
        }
    }

    var bodyRequestable: BodyRequestable? {
        switch self {
        case .getUpcomingMovies: return nil
        case .getPopularMovies: return nil
        case .searchForMovies: return nil
        }
    }
}

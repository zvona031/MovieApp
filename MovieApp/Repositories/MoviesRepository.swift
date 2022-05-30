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
    func getUpcomingMovies(with paginationQuery: QueryRequestable) -> AnyPublisher<MovieListResponse, Error>
    func getPopularMovies(with paginationQuery: QueryRequestable) -> AnyPublisher<MovieListResponse, Error>
    func getFavoriteMovies() -> Results<MovieLocal>
    func searchForMovies(with searchQuery: QueryRequestable) -> AnyPublisher<MovieListResponse, Error>
    func isMovieFavorite(with id: Int) -> Bool
    func saveFavoriteMovie(movie: MovieLocal)
    func removeFavoriteMovie(movie: MovieLocal)
}

final class MoviesRepositoryImpl: MoviesRepository {
    @Injected private var networkService: Networking
    @Injected private var databaseService: DatabaseService

    func getUpcomingMovies(with paginationQuery: QueryRequestable) -> AnyPublisher<MovieListResponse, Error> {
        networkService.request(endpoint: Endpoint.getUpcomingMovies(paginationQuery))
    }

    func getPopularMovies(with paginationQuery: QueryRequestable) -> AnyPublisher<MovieListResponse, Error> {
        networkService.request(endpoint: Endpoint.getPopularMovies(paginationQuery))
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
        case getUpcomingMovies(QueryRequestable)
        case getPopularMovies(QueryRequestable)
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
        case .getUpcomingMovies(let paginationQuery): return paginationQuery
        case .getPopularMovies(let paginationQuery): return paginationQuery
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

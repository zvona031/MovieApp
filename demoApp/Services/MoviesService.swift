//
//  MoviesService.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 02.05.2022..
//

import Foundation
import Combine
import Resolver

protocol MoviesService {
    func getLatestMovies(with queryRequest: QueryRequestable) -> AnyPublisher<MovieListResponse, Error>
    func getPopularMovies(with queryRequest: QueryRequestable) -> AnyPublisher<MovieListResponse, Error>
//    func getFavoriteMovies(with queryRequest: QueryRequestable) -> AnyPublisher<MovieListResponse, Error>
}

final class MoviesServiceImpl: MoviesService {
    @Injected private var networkClient: Networking

    func getLatestMovies(with queryRequest: QueryRequestable) -> AnyPublisher<MovieListResponse, Error> {
        networkClient.request(endpoint: Endpoint.getLatestMovies(queryRequest))
    }

    func getPopularMovies(with queryRequest: QueryRequestable) -> AnyPublisher<MovieListResponse, Error> {
        networkClient.request(endpoint: Endpoint.getPopularMovies(queryRequest))
    }

//    func getFavoriteMovies(with queryRequest: QueryRequestable) -> AnyPublisher<MovieListResponse, Error> {
//    }

}

// MARK: - Endpoints

extension MoviesServiceImpl {
    enum Endpoint {
        case getLatestMovies(QueryRequestable)
        case getPopularMovies(QueryRequestable)
    }
}

extension MoviesServiceImpl.Endpoint: APIConfigurable {
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
        case .getPopularMovies(let queryRequestable): return queryRequestable
        }
    }

    var bodyRequestable: BodyRequestable? {
        switch self {
        case .getLatestMovies: return nil
        case .getPopularMovies: return nil
        }
    }
}

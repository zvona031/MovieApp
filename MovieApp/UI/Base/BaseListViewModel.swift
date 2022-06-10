//
//  BaseViewModel.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 23.05.2022..
//

import Resolver
import Combine
import Foundation

class BaseViewModel {
    var itemType: TabBarItemType
    @Injected private(set) var moviesRepository: MoviesRepository
    @Published var movies: [MoviePresent] = []
    var currentPage: Int = 1
    var totalPages: Int = 1
    var subscriptions = Set<AnyCancellable>()
    var paginationInProgress = false

    init(withType itemType: TabBarItemType) {
        self.itemType = itemType
        registerObservers()
    }

    func getMovies() {
        currentPage = 1
        switch itemType {
        case .upcoming:
            getUpcomingMovies()
        case .popular:
            getPopularMovies()
        case .favorite:
            getFavoriteMovies()
        case .search:
            return
        }
    }

    func paginateMovies() {
        guard totalPages >= currentPage + 1,
        paginationInProgress == false else { return }
        currentPage += 1
        paginationInProgress = true
        switch itemType {
        case .upcoming:
            getUpcomingMovies()
        case .popular:
            getPopularMovies()
        case .favorite:
            getFavoriteMovies()
        case .search:
            return
        }
    }

    func getPopularMovies() {
        fatalError("Must Override")
    }

    func getFavoriteMovies() {
        fatalError("Must Override")
    }

    func getUpcomingMovies() {
        fatalError("Must Override")
    }

    func searchForMovies(with searchText: String) {
        fatalError("Must Override")
    }

    func favoriteClicked(with movie: MoviePresent) {
        NotificationCenter.default.post(name: .favoriteClicked, object: nil, userInfo: ["movie": movie, "itemType": itemType])
        updateDataSource(with: movie)
        updateDatabase(with: movie)
    }

    private func registerObservers() {
        NotificationCenter.default.addObserver(forName: .favoriteClicked, object: nil, queue: nil) { [weak self] notification in
            guard let welf = self,
                  let movie = notification.userInfo?["movie"] as? MoviePresent,
                  let itemType = notification.userInfo?["itemType"] as? TabBarItemType,
                  itemType != welf.itemType else { return }
            welf.updateDataSource(with: movie)
        }
    }

    private func updateDataSource(with movie: MoviePresent) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            if itemType == .favorite {
                movies.remove(at: index)
            } else {
                movies[index] = movie
            }
        } else if itemType == .favorite {
            movies.insert(movie, at: 0)
        }
    }

    private func updateDatabase(with movie: MoviePresent) {
        if movie.isFavorite {
            moviesRepository.saveFavoriteMovie(movie: movie.mapToLocal())
        } else {
            moviesRepository.removeFavoriteMovie(movie: movie.mapToLocal())
        }
    }
}

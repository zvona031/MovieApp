//
//  MovieListController.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 28.04.2022..
//

import Foundation
import UIKit
import Resolver
import Combine

class MovieListController: BaseListViewController {
    // MARK: - Properties
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func config(with viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        self.title = viewModel.itemType.tabBarTitle
        self.tabBarItem = viewModel.itemType.tabBarItem
    }

    override func collectionViewSetup() {
        super.collectionViewSetup()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    @objc private func refreshData() {
        getMovies()
    }

    override func dataBinding() {
        viewModel.$movies.sink { movies in
            self.applySnapshot(with: movies)
            self.refreshControl.endRefreshing()
        }
        .store(in: &subscriptions)
    }
}

//
//  MovieSearchViewController.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 23.05.2022..
//

import Resolver
import UIKit
import Combine

class MovieSearchViewController: BaseListViewController {
    @IBOutlet private weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetup()
        dataBinding()
        getMovies()
    }

    func config(with viewModel: MovieSearchViewModel) {
        self.viewModel = viewModel
        self.title = viewModel.itemType.tabBarTitle
        self.tabBarItem = viewModel.itemType.tabBarItem
    }

    override func dataBinding() {
        viewModel.$movies.sink { movies in
            self.applySnapshot(with: movies)
        }
        .store(in: &subscriptions)
    }
}

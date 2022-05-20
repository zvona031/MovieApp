//
//  MovieListController.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 28.04.2022..
//

import Foundation
import UIKit
import Resolver
import Combine

class MovieListController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!

    enum Section {
        case main
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, MoviePresent>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MoviePresent>

    // MARK: - Properties
    private var subscriptions = Set<AnyCancellable>()
    private var viewModel: MovieListViewModel!
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, movie -> MovieCollectionViewCell? in
            let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.config(with: movie, delegate: self)
            return cell
            })
        return dataSource
    }()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetup()
        dataBinding()
        getMovies()
        registerObservers()
    }

    func config(with viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        self.title = viewModel.itemType.tabBarTitle
        self.tabBarItem = viewModel.itemType.tabBarItem
    }

    private func collectionViewSetup() {
        collectionView.delegate = self
        collectionView.registerNib(MovieCollectionViewCell.self)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    @objc private func refreshData() {
        getMovies()
    }

    func dataBinding() {
        viewModel.$movies.sink { movies in
            self.applySnapshot(with: movies)
            self.refreshControl.endRefreshing()
        }
        .store(in: &subscriptions)
    }

    func getMovies() {
        viewModel.getMovies()
    }

    func applySnapshot(with movies: [MoviePresent]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionView
extension MovieListController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.size.width / 2
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = viewModel.movies.self[safe: indexPath.row] else {return}
        showMovieDetails(for: movie)
    }
}

extension MovieListController {
    func showMovieDetails(for movie: MoviePresent) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller: MovieDetailsController = storyBoard.getController()
        controller.config(with: Resolver.resolve(args: movie))
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension MovieListController: MovieCellDelegate {
    func favoriteClicked(with movie: MoviePresent) {
        if viewModel.itemType == .favorite {
            var currentSnapshot = dataSource.snapshot()
            currentSnapshot.deleteItems([movie])
            dataSource.apply(currentSnapshot)
        }
        viewModel.favoriteClicked(with: movie)
    }


    private func registerObservers() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("favoriteClicked"), object: nil, queue: nil) { [weak self] notification in
            guard let welf = self,
                  let movie = notification.userInfo?["movie"] as? MoviePresent,
                  let itemType = notification.userInfo?["itemType"] as? TabBarItemType,
                  welf.viewModel.itemType != itemType else {return}
            if welf.viewModel.itemType == .favorite {
                welf.addRemoveOnFavoriteTab(with: movie)
            } else {
                welf.reloadItemOnUnselectedTabs(with: movie)
            }
        }
    }

    private func addRemoveOnFavoriteTab(with movie: MoviePresent) {
        var currentSnapshot = self.dataSource.snapshot()
        if let currentMovie =  currentSnapshot.itemIdentifiers.first(where: { moviePresent in
            moviePresent.id == movie.id
        }) {
            currentSnapshot.deleteItems([currentMovie])
        } else {
            print("Movie in tabItem: \(viewModel.itemType) has isFavorite value: \(movie.isFavorite) after toggle")
            let newMovie: MoviePresent = movie.copy() as! MoviePresent
            currentSnapshot.appendItems([newMovie])
        }
        self.dataSource.apply(currentSnapshot, animatingDifferences: false, completion: nil)
    }

    private func reloadItemOnUnselectedTabs(with clickedMovie: MoviePresent) {
        let currentSnapshot = dataSource.snapshot()
        if let movie = currentSnapshot.itemIdentifiers.first(where: { moviePresent in
            moviePresent.id == clickedMovie.id
        }) {
            movie.toggleIsFavorite()
            print("Movie in tabItem: \(viewModel.itemType) has isFavorite value: \(movie.isFavorite) after toggle")

            var newSnapshot = dataSource.snapshot()
            newSnapshot.reloadItems([movie])
            self.dataSource.apply(newSnapshot, animatingDifferences: false, completion: nil)
        }
    }

}

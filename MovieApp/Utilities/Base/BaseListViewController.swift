//
//  BaseListViewModel.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 23.05.2022..
//

import Foundation
import Combine
import UIKit
import Resolver

class BaseListViewController: UIViewController {
    enum Section {
        case movieList
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, MoviePresent>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MoviePresent>

    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Properties
    var viewModel: BaseViewModel!
    var subscriptions = Set<AnyCancellable>()
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, movie -> MovieCollectionViewCell? in
            let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.config(with: movie, delegate: self)
            return cell
            })
        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetup()
        dataBinding()
        getMovies()
        registerObservers()
    }

    func collectionViewSetup() {
        collectionView.registerNib(MovieCollectionViewCell.self)
        collectionView.collectionViewLayout = generateLayout()
    }

    func getMovies() {
        viewModel.getMovies()
    }

    func dataBinding() {
        fatalError("Must Override")
    }

    func applySnapshot(with movies: [MoviePresent]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.movieList])
        snapshot.appendItems(movies)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

    // MARK: - Collection view stuff extension
extension BaseListViewController {
    private func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = viewModel.movies.self[safe: indexPath.row] else { return }
        showMovieDetails(for: movie)
    }

    private func generateLayout() -> UICollectionViewLayout {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: fullPhotoItem,
            count: 3)
        // Section
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// MARK: - MovieCellDelegate extension
extension BaseListViewController: MovieCellDelegate {
    func favoriteClicked(with movie: MoviePresent) {
        if viewModel.itemType == .favorite {
            var currentSnapshot = dataSource.snapshot()
            currentSnapshot.deleteItems([movie])
            dataSource.apply(currentSnapshot)
        }
        viewModel.favoriteClicked(with: movie)
    }

    func showMovieDetails(for movie: MoviePresent) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller: MovieDetailsController = storyBoard.getController()
        controller.config(with: Resolver.resolve(args: movie))
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - Observing stuff extension
extension BaseListViewController {
    private func registerObservers() {
        NotificationCenter.default.addObserver(forName: .favoriteClicked, object: nil, queue: nil) { [weak self] notification in
            guard let welf = self,
                  let movie = notification.userInfo?["movie"] as? MoviePresent,
                  let itemType = notification.userInfo?["itemType"] as? TabBarItemType,
                  welf.viewModel.itemType != itemType else { return }
            if welf.viewModel.itemType == .favorite {
                welf.updateFavoriteTabData(with: movie)
            } else {
                welf.reloadItemOnUnselectedTabs(with: movie)
            }
        }
    }

    func updateFavoriteTabData(with movie: MoviePresent) {
        var currentSnapshot = self.dataSource.snapshot()
        if let currentMovie = currentSnapshot.itemIdentifiers.first( where: { moviePresent in
            moviePresent.id == movie.id
        }) {
            currentSnapshot.deleteItems([currentMovie])
        } else {
            if let newMovie: MoviePresent = movie.copy() as? MoviePresent {
                if let firstItem = currentSnapshot.itemIdentifiers.first {
                    currentSnapshot.insertItems([newMovie], beforeItem: firstItem)
                } else {
                    currentSnapshot.appendItems([newMovie])
                }
            }
        }
        self.dataSource.apply(currentSnapshot, animatingDifferences: false, completion: nil)
    }

    func reloadItemOnUnselectedTabs(with clickedMovie: MoviePresent) {
        let currentSnapshot = dataSource.snapshot()
        if let movie = currentSnapshot.itemIdentifiers.first(where: { moviePresent in
            moviePresent.id == clickedMovie.id
        }) {
            movie.toggleIsFavorite()
            var newSnapshot = dataSource.snapshot()
            newSnapshot.reloadItems([movie])
            self.dataSource.apply(newSnapshot, animatingDifferences: false, completion: nil)
        }
    }
}

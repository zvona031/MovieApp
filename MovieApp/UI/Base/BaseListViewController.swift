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
        collectionView.delegate = self
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
extension BaseListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = viewModel.movies.self[safe: indexPath.row] else { return }
        showMovieDetails(for: movie)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("Index row: \(indexPath.row)")
        print("Pagination trigger point: \(viewModel.movies.count - 3)")
        guard indexPath.row > viewModel.movies.count - 3 else {
            print("Ne treba paginacija")
            return
        }
        viewModel.paginateMovies()
    }

    private func generateLayout() -> UICollectionViewLayout {
        // Small cover item
        let smallCoverItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        // Group of 3 horizontal smallCoverItems
        let horiontalSmallGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1 / 6)),
            subitem: smallCoverItem,
            count: 3)

        let bigCoverItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(2 / 3),
                heightDimension: .fractionalHeight(1.0)))

        let verticalSmallGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1 / 3),
                heightDimension: .fractionalHeight(1.0)),
            subitem: smallCoverItem,
            count: 2)

        let mainWithPairGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(2 / 6)),
            subitems: [bigCoverItem, verticalSmallGroup])

        let mainWithPairInverseGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(2 / 6)),
            subitems: [verticalSmallGroup, bigCoverItem])

        let finalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(3)),
            subitems: [horiontalSmallGroup, mainWithPairGroup, horiontalSmallGroup, mainWithPairInverseGroup])

        // Section
        let section = NSCollectionLayoutSection(group: finalGroup)
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

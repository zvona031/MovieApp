//
//  BaseListViewModel.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 23.05.2022..
//

import Foundation
import Combine
import UIKit
import Resolver

protocol BaseListViewProtocol {
    
}

class BaseListViewController: UIViewController {
    enum Section {
        case main
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, MoviePresent>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MoviePresent>

    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Properties
    var viewModel: BaseViewModel!
    private (set) var subscriptions = Set<AnyCancellable>()
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
    }

    func getMovies() {
        viewModel.getMovies()
    }

    func dataBinding() {
        fatalError("Must Override")
    }

    func applySnapshot(with movies: [MoviePresent]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension BaseListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.size.width / 2
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = viewModel.movies.self[safe: indexPath.row] else { return }
        showMovieDetails(for: movie)
    }
}

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

    private func registerObservers() {
        NotificationCenter.default.addObserver(forName: .favoriteClicked, object: nil, queue: nil) { [weak self] notification in
            guard let welf = self,
                  let movie = notification.userInfo?["movie"] as? MoviePresent,
                  let itemType = notification.userInfo?["itemType"] as? TabBarItemType,
                  welf.viewModel.itemType != itemType else { return }
            if welf.viewModel.itemType == .favorite {
                welf.addRemoveOnFavoriteTab(with: movie)
            } else {
                welf.reloadItemOnUnselectedTabs(with: movie)
            }
        }
    }

    func addRemoveOnFavoriteTab(with movie: MoviePresent) {
        var currentSnapshot = self.dataSource.snapshot()
        if let currentMovie = currentSnapshot.itemIdentifiers.first( where: { moviePresent in
            moviePresent.id == movie.id
        }) {
            currentSnapshot.deleteItems([currentMovie])
        } else {
            if let newMovie: MoviePresent = movie.copy() as? MoviePresent, let firstItem = currentSnapshot.itemIdentifiers.first {
                currentSnapshot.insertItems([newMovie], beforeItem: firstItem)
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

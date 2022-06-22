//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 30.04.2022..
//

import Kingfisher
import UIKit
import Combine

class MovieCollectionViewCell: UICollectionViewCell {
    private var movie: MoviePresent!
    private let tapSubject = PassthroughSubject<MoviePresent, Never>()
    var subscriptions = Set<AnyCancellable>()
    lazy var tapPublisher: AnyPublisher<MoviePresent, Never> = {
        self.tapSubject.eraseToAnyPublisher()
    }()

    // MARK: - IBOutlets
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var heartButton: UIButton!

    override func prepareForReuse() {
        subscriptions.removeAll()
    }

    final func config(with movie: MoviePresent) {
        self.movie = movie
        self.heartButton.isSelected = movie.isFavorite
        coverImage.kf.indicatorType = .activity
        coverImage.kf.setImage(with: movie.moviePosterUrl)
    }

    @IBAction func hearButtonTapped(_ sender: Any) {
        movie.toggleIsFavorite()
        tapSubject.send(movie)
    }
}

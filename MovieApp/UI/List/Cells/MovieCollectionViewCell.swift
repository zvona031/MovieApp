//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 30.04.2022..
//

import Kingfisher
import UIKit

protocol MovieCellDelegate: AnyObject {
    func favoriteClicked(with movie: MoviePresent)
}

class MovieCollectionViewCell: UICollectionViewCell {
    private var delegate: MovieCellDelegate!
    private var movie: MoviePresent!

    // MARK: - IBOutlets
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var heartButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }


    final func config(with movie: MoviePresent, delegate: MovieCellDelegate) {
        self.delegate = delegate
        self.movie = movie
        self.heartButton.isSelected = movie.isFavorite
        coverImage.kf.indicatorType = .activity
        coverImage.kf.setImage(with: movie.moviePosterUrl)
    }

    @IBAction func hearButtonTapped(_ sender: Any) {
        movie.toggleIsFavorite()
        delegate?.favoriteClicked(with: movie)
        heartButton.isSelected.toggle()
    }
}

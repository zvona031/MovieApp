//
//  MovieCollectionViewCell.swift
//  demoApp
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
        let url = URL(string: "https://image.tmdb.org/t/p/w400" + movie.posterPath)
        coverImage.kf.indicatorType = .activity
        coverImage.kf.setImage(with: url)
    }

    @IBAction func hearButtonTapped(_ sender: Any) {
        delegate?.favoriteClicked(with: movie)
        heartButton.isSelected.toggle()
    }
}

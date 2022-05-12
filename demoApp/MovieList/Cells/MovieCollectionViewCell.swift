//
//  MovieCollectionViewCell.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 30.04.2022..
//

import Kingfisher
import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var heartButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }


    final func config(with movie: Movie) {
        let url = URL(string: "https://image.tmdb.org/t/p/w400" + movie.posterPath)
        coverImage.kf.indicatorType = .activity
        coverImage.kf.setImage(with: url)
    }

    @IBAction func hearButtonTapped(_ sender: Any) {
        heartButton.isSelected.toggle()
    }
}

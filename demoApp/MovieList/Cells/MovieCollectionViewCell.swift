//
//  MovieCollectionViewCell.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 30.04.2022..
//

import Foundation
import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var heartButton: UIButton!

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    final func config(with movie: Movie) {
        heartButton.isSelected = movie.isFavorite
    }

    @IBAction func hearButtonTapped(_ sender: Any) {
        heartButton.isSelected.toggle()
    }
}

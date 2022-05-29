//
//  MovieDetailsController.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 17.05.2022..
//

import Resolver
import UIKit

class MovieDetailsController: UIViewController {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!

    private var viewModel: MovieDetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setMovieDetails()
    }

    final func config(with viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
    }

    private func setMovieDetails() {
        movieTitleLabel.text = viewModel.movie.originalTitle
        coverImageView.kf.indicatorType = .activity
        coverImageView.kf.setImage(with: viewModel.moviePosterUrl)
    }
}

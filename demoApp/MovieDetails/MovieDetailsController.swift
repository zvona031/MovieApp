//
//  MovieDetailsController.swift
//  demoApp
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
        movieTitleLabel.text = viewModel.movie.originalTitle
        let url = URL(string: "https://image.tmdb.org/t/p/w400" + viewModel.movie.posterPath)
        coverImageView.kf.indicatorType = .activity
        coverImageView.kf.setImage(with: url)
    }

    final func config(with viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel

    }
}

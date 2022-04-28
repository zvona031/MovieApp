//
//  MovieListController.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 28.04.2022..
//

import Foundation
import UIKit
import Resolver

class MovieListController: UIViewController {
    private var viewModel: MovieListViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func config(with viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        self.title = viewModel.itemType.title
    }
}

//
//  ViewController.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 27.04.2022..
//

import UIKit
import Resolver
import Combine

struct MovieTapping {
    let movie: MoviePresent
    let itemType: TabBarItemType
}

class TabBarController: UITabBarController {
    var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    func setupTabBar() {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var controllers: [UIViewController] = []
        for itemType in TabBarItemType.allCases {
            switch itemType {
            case .search:
                let controller: MovieSearchViewController = storyBoard.getController()
                controller.config(with: Resolver.resolve(args: itemType))
                let navigationController = UINavigationController(rootViewController: controller)
                controllers.append(navigationController)
            default:
                let controller: MovieListController = storyBoard.getController()
                controller.config(with: Resolver.resolve(args: itemType))
                controller.tapPublisher.sink { movieTapped in
                    self.printaj(movie: movieTapped)
                }.store(in: &subscriptions)
                let navigationController = UINavigationController(rootViewController: controller)
                controllers.append(navigationController)
            }
        }
        self.setViewControllers(controllers, animated: true)
    }

    private func printaj(movie: MovieTapping) {
        viewControllers?.forEach({ controller in
            guard let baseController = controller.children.first as? BaseListViewController, baseController.viewModel.itemType != movie.itemType else {return}
            baseController.movieTapped(with: movie)
        })
    }
}

//
//  ViewController.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 27.04.2022..
//

import UIKit
import Resolver
import Combine

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
                controller.favoriteActionPublisher.sink { favoritedAction in
                    self.handleFavoritedMovieAction(action: favoritedAction)
                }
                .store(in: &subscriptions)
                let navigationController = UINavigationController(rootViewController: controller)
                controllers.append(navigationController)
            }
        }
        self.setViewControllers(controllers, animated: true)
    }

    private func handleFavoritedMovieAction(action: FavoritedMovieAction) {
        viewControllers?.forEach({ controller in
            guard let baseController = controller.children.first as? BaseListViewController, baseController.viewModel.itemType != action.itemType else {return}
            baseController.handleFavoritedMovieAction(with: action)
        })
    }
}

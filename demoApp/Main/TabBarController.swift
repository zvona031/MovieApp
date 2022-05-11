//
//  ViewController.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 27.04.2022..
//

import UIKit
import Resolver

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        // Do any additional setup after loading the view.
    }

    func setupTabBar() {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var controllers: [UIViewController] = []
        for itemType in TabBarItemType.allCases {
            let controller: MovieListController = storyBoard.getController()
            controller.config(with: Resolver.resolve(args: itemType))
            controller.tabBarItem = itemType.tabBarItem
            controllers.append(controller)
        }
        self.setViewControllers(controllers, animated: true)
    }
}

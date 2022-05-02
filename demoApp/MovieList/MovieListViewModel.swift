//
//  MovieListViewModel.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 28.04.2022..
//

import Foundation
import Resolver
import UIKit

final class MovieListViewModel {
    let itemType: TabBarItemType
    @Injected private var moviesService: MoviesService

    init(withType itemType: TabBarItemType) {
        self.itemType = itemType
    }
}

enum TabBarItemType: CaseIterable {
    case latest
    case popular
    case favorite
    case search

    var tabBarTitle: String {
        switch self {
        case .latest:
            return "Latest"
        case .popular:
            return "Popular"
        case .favorite:
            return "Favorite"
        case .search:
            return "Search"
        }
    }

    var tabBarImage: UIImage? {
        switch self {
        case .latest:
            return UIImage(systemName: "timer")
        case .popular:
            return UIImage(systemName: "flame")
        case .favorite:
            return UIImage(systemName: "star")
        case .search:
            return UIImage(systemName: "magnifyingglass")
        }
    }

    var tabBarItem: UITabBarItem {
        return UITabBarItem(title: tabBarTitle, image: tabBarImage, tag: self.hashValue)
    }
}

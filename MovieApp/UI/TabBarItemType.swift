//
//  TabBarItemType.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 11.05.2022..
//

import UIKit

enum TabBarItemType: CaseIterable {
    case popular
    case upcoming
    case favorite
    case search

    var tabBarTitle: String {
        switch self {
        case .upcoming:
            return "Upcoming"
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
        case .upcoming:
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

//
//  MovieListViewModel.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 28.04.2022..
//

import Foundation
import Resolver
import UIKit

enum TabBarItemType: CaseIterable {
    case latest
    case popular
    case favorite
    case search

    var title: String {
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

    var tabBarItem: UITabBarItem {
        return UITabBarItem(title: title, image: UIImage.actions, tag: self.hashValue)
    }
}

final class MovieListViewModel {

    let itemType: TabBarItemType

    init(withType itemType: TabBarItemType) {
        self.itemType = itemType
    }
}

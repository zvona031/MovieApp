//
//  AppDelegate+Injection.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 27.04.2022..
//

import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {

        register { _, args in
            MovieListViewModel(withType: args())
        }
    }
}

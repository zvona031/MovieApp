//
//  AppDelegate+Injection.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 27.04.2022..
//

import Resolver
import Alamofire

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { AuthRequestInterceptor() as RequestInterceptor }

        register { NetworkService(session: AF, interceptor: resolve()) as Networking }

        register { DatabaseServiceImpl() as DatabaseService }

        register { MoviesRepositoryImpl() as MoviesRepository }

        register { _, args in MovieListViewModel(withType: args()) }

        register { _, args in MovieDetailsViewModel(for: args()) }
    }
}

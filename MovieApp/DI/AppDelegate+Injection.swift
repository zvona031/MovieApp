//
//  AppDelegate+Injection.swift
//  MovieApp
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

        register { _, args in MovieListViewModel(withType: args()) }.implements(BaseViewModel.self)

        register { _, args in MovieSearchViewModel(withType: args()) }.implements(BaseViewModel.self)

        register { _, args in MovieDetailsViewModel(for: args()) }
    }
}

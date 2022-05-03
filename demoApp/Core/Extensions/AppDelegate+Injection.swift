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

        register { NetworkClient(session: AF, interceptor: resolve()) as Networking }

        register { MoviesServiceImpl() as MoviesService }

        register { MoviesRemoteRepositoryImpl() as MoviesRemoteRepository }

        register { _, args in MovieListViewModel(withType: args()) }
    }
}

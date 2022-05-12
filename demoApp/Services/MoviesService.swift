//
//  MoviesService.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 03.05.2022..
//

import Foundation
import Combine
import Resolver

protocol MoviesService {}

final class MoviesServiceImpl: MoviesService {
    @Injected private var remoteRepository: MoviesRemoteRepositoryImpl
}

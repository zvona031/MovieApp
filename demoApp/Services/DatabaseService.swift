//
//  MoviesService.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 03.05.2022..
//

import Foundation
import Combine
import RealmSwift

protocol DatabaseService {
    func getFavoriteMovies() -> Results<MovieLocal>
    func saveFavoriteMovie(with movie: MovieLocal)
    func removeFavoriteMovie(with movie: MovieLocal)
}

final class DatabaseServiceImpl: DatabaseService {
    var realm: Realm!

    init() {
        do {
            realm = try Realm()
        } catch {}
    }

    func getFavoriteMovies() -> Results<MovieLocal> {  realm.objects(MovieLocal.self)
    }

    func saveFavoriteMovie(with movie: MovieLocal) {
        do {
            try realm.write({
                realm.add(movie)
            })
        } catch {

        }
    }

    func removeFavoriteMovie(with movie: MovieLocal) {
        do {
            try realm.write({
                realm.delete(realm.objects(MovieLocal.self).filter("id=%@",movie.id))
            })
        } catch {

        }
    }
}

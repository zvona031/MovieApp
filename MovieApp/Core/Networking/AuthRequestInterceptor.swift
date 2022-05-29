//
//  AuthRequestInterceptor.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 02.05.2022..
//

import Foundation
import Alamofire

class AuthRequestInterceptor: RequestInterceptor {
    static var apiKey = ["api_key": "99460c4f7bd0cd6322c499e1c5d99677"]

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest

        let encoding = URLEncodedFormParameterEncoder.default
        if let request = try? encoding.encode(AuthRequestInterceptor.apiKey, into: urlRequest) {
            urlRequest = request
        }

        completion(.success(urlRequest))
    }
}

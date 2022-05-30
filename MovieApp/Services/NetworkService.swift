//
//  NetworkClient.swift
//  MovieApp
//
//  Created by Zvonimir Pavlović on 02.05.2022..
//

import Foundation
import Alamofire
import Combine

protocol Networking {
    func request<Value>(endpoint: URLRequestConvertible) -> AnyPublisher<Value, Error> where Value: Decodable
}

class NetworkService: Networking {
    private let session: Session
    private let interceptor: RequestInterceptor

    init(session: Session, interceptor: RequestInterceptor) {
        self.session = session
        self.interceptor = interceptor
    }

    func request<Value>(endpoint: URLRequestConvertible) -> AnyPublisher<Value, Error> where Value: Decodable {
        session
            .request(endpoint, interceptor: interceptor)
            .cURLDescription(calling: { curl in
                print(curl)
            })
            .validate()
            .publishDecodable(type: Value.self)
            .tryMap {
                guard let code = $0.response?.statusCode else {
                    throw NetworkError.unexpectedResponse
                }
                guard HTTPCodes.success.contains(code) else {
                    throw NetworkError.httpCode(code)
                }
                guard let data = $0.data else {
                    throw DataError.missing
                }
                return data
            }
            .decode(type: Value.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { decodable in
//                print("Response: ", decodable)
            })
            .eraseToAnyPublisher()
    }
}

//
//  ApiConfigurable.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 02.05.2022..
//

import Foundation
import Alamofire
import Resolver

typealias HTTPMethod = Alamofire.HTTPMethod

typealias PathParameter = Int
protocol QueryRequestable: Encodable {}
protocol BodyRequestable: Encodable {}

protocol APIConfigurable: URLRequestConvertible {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryRequestable: QueryRequestable? { get }
    var bodyRequestable: BodyRequestable? { get }
}

extension APIConfigurable {
    var baseURL: String {
        return "https://api.themoviedb.org/3"
    }

    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()

        var urlRequest = URLRequest(url: url.appendingPathComponent(path))

        // HTTP Method
        urlRequest.httpMethod = method.rawValue

        // Headers
        urlRequest.allHTTPHeaderFields = headers

        // Query Parameters
        if let queryParameters = self.queryRequestable?.asDictionary {
            let parameters = queryParameters.map { pair  in
                return URLQueryItem(name: pair.key, value: "\(pair.value)")
            }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = parameters
            urlRequest.url = components?.url
        }


        // Body
        // FIXME: - Add Content-Type application/json headers here and remove them from repositories
        if let bodyRequestable = self.bodyRequestable {
            urlRequest.httpBody = try bodyRequestable.asJSON()
        }
        return urlRequest
    }
}

enum NetworkError: Error {
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case let .httpCode(code): return "Unexpected HTTP code: \(code)"
        case .unexpectedResponse: return "Unexpected server response"
        }
    }
}

enum DataError: Error {
    case missing
    case decoder
    case malformed
}

extension DataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .missing: return "Missing data"
        case .decoder: return "Decoder error"
        case .malformed: return "Malformed data"
        }
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}

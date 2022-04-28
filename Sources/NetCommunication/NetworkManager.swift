//
//  NetworkManager.swift
//  
//
//  Created by Chang Chu on 4/28/22.
//

import Combine
import Foundation

public enum NetworkManager {
    public static var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return URLSession(configuration: configuration)
    }

    public static func fetch<T: Decodable>(type _: T.Type, with endpoint: Endpoint) -> AnyPublisher<T, NetError> {
        guard let urlRequest = endpoint.buildRequest() else {
            let url = "\(endpoint.baseURL)\(endpoint.path ?? "")"
            return Fail<T, NetError>(error: NetError.buildURLRequestFailed(url)).eraseToAnyPublisher()
        }

        return session
            .dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse else {
                    throw NetError.other("invalid response")
                }

                guard 200 ..< 300 ~= response.statusCode else {
                    throw NetError(statusCode: response.statusCode)
                }

                return data
            }
            .decodeAndMapError(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}


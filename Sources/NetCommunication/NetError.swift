//
//
// NetError.swift
//  
//
//  Created by Chang Chu on 4/28/22.
//

import Combine
import Foundation

public enum NetError: Error {
    case other(_ errorMessage: String)

    case decodingFailed(_ className: String)
    case endcodingFailed(_ className: String)
    case buildURLRequestFailed(_ url: String)
    case invalidURL(_ url: String?)
    case noData

    case informationalResponse
    case successfulResponse
    case noChange
    case redirects
    case badRequest
    case tokenExpired
    case authenticationError
    case resourceNotFound
    case requestTimeout
    case serverThrottling
    case otherClientError
    case serverError
    case otherNetworkError
}

public extension NetError {
    init(statusCode: Int) {
        switch statusCode {
        case 100 ... 199: self = .informationalResponse
        case 200 ... 299: self = .successfulResponse
        case 304: self = .noChange
        case 300 ... 399: self = .redirects
        case 400: self = .badRequest
        case 401: self = .tokenExpired
        case 403: self = .authenticationError
        case 404: self = .resourceNotFound
        case 408: self = .requestTimeout
        case 429: self = .serverThrottling
        case 400 ... 499: self = .otherClientError
        case 500 ... 599: self = .serverError
        default: self = .otherNetworkError
        }
    }
}

extension Publisher {
    func decodeAndMapError<Item, Coder>(type: Item.Type, decoder: Coder) -> AnyPublisher<Item, NetError> where Item: Decodable, Coder: TopLevelDecoder, Self.Output == Coder.Input {
        return decode(type: type, decoder: decoder)
            .mapError { error in
                switch error {
                case is Swift.DecodingError:
                    return NetError.decodingFailed(String(describing: type))
                case let myError as NetError:
                    return myError
                default:
                    return NetError.other(error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
}

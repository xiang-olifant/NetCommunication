//
//  File.swift
//  
//
//  Created by Chang Chu on 4/28/22.
//

import Foundation

public protocol Endpoint {
    var baseURL: String { get }
    var path: String? { get }
    var scheme: URLScheme { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
}

public enum URLScheme {
    case http
    case https
}

public enum HTTPMethod {
    case get
    case post
    case put
    case delete
    case patch
}

extension Endpoint {
    func buildRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "\(scheme)"
        urlComponents.host = baseURL
        if let urlPath = path { urlComponents.path = urlPath }
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "\(method)".capitalized
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }
}


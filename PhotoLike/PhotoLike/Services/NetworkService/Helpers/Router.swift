//
//  Router.swift
//  PhotoLike
//
//  Created by Arsenii Kovalenko on 26.10.2022.
//

import Foundation

protocol Route {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var headers: [String: String] { get }
    var queryItems: [String: LosslessStringConvertible] { get }
    var httpMethod: HTTPMethod { get }
    var body: [String: Any]? { get }
}

extension Route {
    var request: URLRequest? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = Array(queryItems)
        
        guard let url = components.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.timeoutInterval = 15
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        if let body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                assertionFailure(error.localizedDescription)
                return nil
            }
        }
        
        return request
    }
}

struct Router: Route {
    let scheme: String
    let host: String
    let path: String
    let headers: [String: String]
    let queryItems: [String: LosslessStringConvertible]
    let httpMethod: HTTPMethod
    let body: [String: Any]?
    
    init(host: String,
         path: String,
         queryItems: [String: LosslessStringConvertible],
         headers: [String: String] = [:],
         scheme: String = "https",
         httpMethod: HTTPMethod = .get,
         body: [String: Any]? = nil) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.headers = headers
        self.queryItems = queryItems
        self.httpMethod = httpMethod
        self.body = body
    }
}

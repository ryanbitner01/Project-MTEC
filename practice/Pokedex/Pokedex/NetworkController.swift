//
//  NetworkController.swift
//  Pokedex
//
//  Created by Ryan Bitner on 5/3/21.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
    
    var string: String {
        return self.rawValue.uppercased()
    }
}

struct NetworkController {
    static func performRequest(for url: URL, method: HTTPMethod, queryParamenters: [String: String]? = nil, body: Data? = nil, completion: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
        var fullURL = url
        if let queryParameters = queryParamenters, let _fullURL = NetworkController.modifyURL(with: queryParameters, to: fullURL) {// Append Qps to end of URL
            fullURL = _fullURL
            
            var urlRequest = URLRequest(url: fullURL)
            urlRequest.httpMethod = method.string
            urlRequest.httpBody = body
            
            let dataTask = URLSession.shared.dataTask(with: url) {(data, response, error) in
                completion?(data, response, error)
            }
            dataTask.resume()
        }
    }

    private static func modifyURL(with queryParameters: [String: String], to url: URL) -> URL? {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryParameters.compactMap({ URLQueryItem(name: $0.key, value: $0.value) })
        
        return urlComponents?.url
    }
}

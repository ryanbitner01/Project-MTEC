//
//  StoreItemController.swift
//  iTunesSearch
//
//  Created by Ryan Bitner on 4/16/21.
//

import Foundation
import UIKit
class StoreItemController {
    
    func fetchItems(matching query: [String: String], completion: @escaping (Result<[StoreItem], Error>) -> Void) {
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search")!
        urlComponents.queryItems = query.map {URLQueryItem(name: $0.key, value: $0.value)}
        let session = URLSession.shared
        let task = session.dataTask(with: urlComponents.url!) {(data, response, error) in
            do {
                let jsonDecoder = JSONDecoder()
                if let data = data {
                    let decodedData = try jsonDecoder.decode(SearchResponse.self, from: data)
                    completion(.success(decodedData.results))
                }
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchArtworkImage(url:URL, completion: @escaping (Result<UIImage, Error>) -> Void){
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let data = data, let imageFromData = UIImage(data: data) {
                completion(.success(imageFromData))
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

//
//  CatController.swift
//  CatAPI
//
//  Created by Ryan Bitner on 5/7/21.
//

import Foundation
import UIKit

class CatController {
    let baseURL = "https://thatcopy.pw/catapi/rest/"
    
    func getCat(completion: @escaping (Result<Cat, Error>) -> Void) {
        let url = URL(string: baseURL)
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            guard error == nil else {
                return completion(.failure(error!))
            }
            if let data = data {
                let jsonDecoder = JSONDecoder()
                guard let decodedCat = try? jsonDecoder.decode(Cat.self, from: data) else {return}
                completion(.success(decodedCat))
            }
        }
        task.resume()
    }
    
    func getCatImage(cat: Cat, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let url = URL(string: cat.url)
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                guard let image = UIImage(data: data) else {return}
                completion(.success(image))
            }
        }
        task.resume()
    }
}

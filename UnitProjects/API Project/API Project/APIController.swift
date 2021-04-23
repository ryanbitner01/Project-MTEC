//
//  APIController.swift
//  API Project
//
//  Created by Ryan Bitner on 4/22/21.
//

import Foundation
import UIKit

class APIController {
    func fetchRandomDogImageURL(completion: @escaping (Result<URL, Error>) -> Void) {
        let url = URL(string: "https://dog.ceo/api/breeds/image/random")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let decodedData = try? jsonDecoder.decode(DogURLResponse.self, from: data)
                guard let imageURL = decodedData?.imageURL else {return}
                completion(.success(imageURL))
            }
        }
        task.resume()
    }
    
    func fetchDogImage(with imageURL: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: imageURL) {(data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchRepresentatives(zip queryZip: String, completion: @escaping (Result<[Representative], Error>) -> Void) {
        let query: [String: String] = ["output": "json", "zip": queryZip]
        
        var urlComponents = URLComponents(string: "http://whoismyrepresentative.com/getall_mems.php")!
        urlComponents.queryItems = query.map {URLQueryItem(name: $0.key, value: $0.value)}
        
        let task = URLSession.shared.dataTask(with: urlComponents.url!) {(data, response, error) in
            do {
                let jsonDecoder = JSONDecoder()
                if let data = data {
                    let decodedJson = try jsonDecoder.decode(RepSearchResponse.self, from: data)
                    completion(.success(decodedJson.results))
                }
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchNobelPrizeWinner(year: String, category: String, completion: @escaping (Result<[NobelPrize], Error>) -> Void) {
        let baseURL = "http://api.nobelprize.org/v1/prize.json"
        let queryItems = ["year": year, "yearTo": year, "category": category].map {URLQueryItem(name: $0.key, value: $0.value)}
        var url = URLComponents(string: baseURL)!
        url.queryItems = queryItems
        
        let task = URLSession.shared.dataTask(with: url.url!) {(data, response, error) in
            if let data = data {
                //data.prettyPrintedJSONString()
                let jsonDecoder = JSONDecoder()
                guard let decodedData = try? jsonDecoder.decode(NobelResponse.self, from: data) else {return}
                print(decodedData.prizes)
                completion(.success(decodedData.prizes))
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}


extension Data {
    func prettyPrintedJSONString() {
        guard
            let jsonObject = try?
                JSONSerialization.jsonObject(with: self,
                                             options: []),
            let jsonData = try?
                JSONSerialization.data(withJSONObject:
                                        jsonObject, options: [.prettyPrinted]),
            let prettyJSONString = String(data: jsonData,
                                          encoding: .utf8) else {
            print("Failed to read JSON Object.")
            return
        }
        print(prettyJSONString)
    }
}

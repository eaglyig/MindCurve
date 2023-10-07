//
//  ClientService.swift
//  MindCurve
//
//  Created by Ihor Orlenko on 01.09.2023.
//

import Foundation

final class ClientService {
    
    static let shared = ClientService()
    
    private init() {}
    
    func fetch(request: URLRequest, completion: @escaping (Result<WordArticle, Error>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                do {
                    let word = try JSONDecoder().decode(WordArticle.self, from: data!)
                    DispatchQueue.main.sync {
                        completion(.success(word))
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }

}

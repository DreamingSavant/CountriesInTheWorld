//
//  CountriesNetworking.swift
//  CountriesInTheWorld
//
//  Created by Roderick Presswood on 12/1/23.
//

import Foundation

let url = ""

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
    case other(Error)
}

protocol NetworkManagerClient {
    func get<T: Decodable>(from urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void)
}

class NetworkManager: NetworkManagerClient {
    
    private let offlineManager: OfflinemanagerActions
    
    init(offlineManager: OfflinemanagerActions = OfflineManager()) {
        self.offlineManager = offlineManager
    }
    
    func get<T: Decodable>(from urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            handleFailure(completion: completion)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.handleFailure(completion: completion)
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                DispatchQueue.main.async {
                    self?.handleFailure(completion: completion)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self?.handleFailure(completion: completion)
                }
                return
            }
            
            do {
                self?.offlineManager.save(data)
                let decodeObject = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodeObject))
                }
            } catch {
                DispatchQueue.main.async {
                    self?.handleFailure(completion: completion)
                }
            }
        }
        
        task.resume()
    }
    
    func handleFailure<T: Decodable>(completion: @escaping (Result<T, NetworkError>)-> Void) {
        if let data = offlineManager.read() {
            do {
                let decodeObject = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodeObject))
                }
            }catch {
                completion(.failure(NetworkError.noData))
            }
        } else {
            completion(.failure(NetworkError.noData))
        }
    }
}

//
//  MockNetworkManager.swift
//  CountriesInTheWorldTests
//
//  Created by Roderick Presswood on on 12/1/23.
//

import Foundation
@testable import CountriesInTheWorld

class MockNetowrkManger: NetworkManagerClient {
    func get<T>(from urlString: String, completion: @escaping (Result<T, CountriesInTheWorld.NetworkError>) -> Void) where T : Decodable {
        if urlString == "success" {
            completion(.success([Country(capital:"The Valley", code: "XCD", name: "East Caribbean dollar", region: "AF"), Country(capital:"Luanda", code: "KG", name: "Angolan kwanza", region: "AOA")] as! T))
        }else  {
            completion(.failure(NetworkError.invalidResponse))
        }
    }
}

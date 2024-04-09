//
//  CountriesViewModel.swift
//  CountriesInTheWorld
//
//  Created by Roderick Presswood on 12/1/23.
//

import Foundation


class CountriesViewModel {
    
    var countries: [Country]?
    var filteredCountries: [Country]?
    
    private let networkManager: NetworkManagerClient
    
    init(networkManager: NetworkManagerClient) {
        self.networkManager = networkManager
    }
    
    func getCountries(url: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        networkManager.get(from: url) { [weak self] (result: Result<[Country], NetworkError>) in
            switch result {
            case .success(let countries):
                guard let self = self else { return }
                print("You got countries", countries)
                self.countries = countries
                self.filteredCountries = countries
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func filterCountries(from searchText: String) {
        guard !searchText.isEmpty else {
            filteredCountries = countries
            return
        }
        filteredCountries = countries?.filter {
            $0.name.lowercased().contains(searchText.lowercased()) || $0.capital.lowercased().contains(searchText.lowercased())
        }
    }
}

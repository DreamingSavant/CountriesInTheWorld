//
//  Countries.swift
//  CountriesInTheWorld
//
//  Created by Roderick Presswood on 12/1/23.
//

import Foundation


// MARK: - Countries
struct Country: Decodable {
    let capital, code: String
    let name: String
    let region: String
}

//
//  OfflineManager.swift
//  CountriesInTheWorld
//
//  Created by MAC on 08/04/24.
//

import Foundation

protocol OfflinemanagerActions {
    func save(_ data: Data) 
    func read() -> Data?
}

struct OfflineManager: OfflinemanagerActions {
  
    var path: URL? {
        guard  let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first  else {
            return nil
        }
        return documentsDirectory.appendingPathComponent("countries")
    }
    
    func save(_ data: Data) {
        do {
            guard let url = path else { return }
            try data.write(to: url)
        } catch {
            print("Error while saving data: \(error)")
        }
    }
    
    func read() -> Data? {
        guard let url = path else { return nil }
        return try? Data(contentsOf: url)
    }
}

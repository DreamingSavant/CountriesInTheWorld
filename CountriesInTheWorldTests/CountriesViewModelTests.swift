//
//  CountriesInTheWorldTests.swift
//  CountriesInTheWorldTests
//
//  Created by Roderick Presswood on on 12/1/23.
//

import XCTest
@testable import CountriesInTheWorld

final class CountriesViewModelTests: XCTestCase {


    func testGetCountiesSuccess() {
        
        // GIVNE
        let networkManager = MockNetowrkManger()
        let viewModel = CountriesViewModel(networkManager: networkManager)

        // WHEN
        
        viewModel.getCountries(url: "success") { result in }
        
        //THEN
        
        XCTAssertEqual(viewModel.countries?.count, 2)
        XCTAssertEqual(viewModel.filteredCountries?.count, 2)
    }
    
    func testGetCountiesFailure() {
        
        // GIVNE
        let networkManager = MockNetowrkManger()
        let viewModel = CountriesViewModel(networkManager: networkManager)

        // WHEN
        
        viewModel.getCountries(url: "") { result in }
        
        //THEN
        
        XCTAssertNil(viewModel.countries)
        XCTAssertNil(viewModel.filteredCountries)
    }
    
    func testSearchUsingCountryName() {
        
        // GIVNE
        let networkManager = MockNetowrkManger()
        let viewModel = CountriesViewModel(networkManager: networkManager)
        viewModel.getCountries(url: "success") { result in }

        // WHEN
        
        viewModel.filterCountries(from:"Angolan")
        
        //THEN
        
        XCTAssertEqual(viewModel.countries?.count, 2)
        XCTAssertEqual(viewModel.filteredCountries?.count, 1)
        XCTAssertEqual(viewModel.filteredCountries?.first?.name, "Angolan kwanza")

    }
    
    func testSearchUsingCountryCapital() {
        
        // GIVNE
        let networkManager = MockNetowrkManger()
        let viewModel = CountriesViewModel(networkManager: networkManager)
        viewModel.getCountries(url: "success") { result in }

        // WHEN
        
        viewModel.filterCountries(from:"Valley")
        
        //THEN
        
        XCTAssertEqual(viewModel.countries?.count, 2)
        XCTAssertEqual(viewModel.filteredCountries?.count, 1)
        XCTAssertEqual(viewModel.filteredCountries?.first?.name, "East Caribbean dollar")
        XCTAssertEqual(viewModel.filteredCountries?.first?.capital, "The Valley")


    }
    
}

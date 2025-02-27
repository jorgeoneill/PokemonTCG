//
//  CardCellViewModelTests.swift
//  PokemonTCG
//
//  Created by Jorge O'Neill on 27/02/2025.
//

import XCTest
@testable import PokemonTCG

final class CardCellViewModelTests: XCTestCase {
    
    // System under test property
    var sut: CardCellView.ViewModel?
    
    override func setUpWithError() throws {
        // Expectation needs to be set and awaited for fullfilment, because of the asynchronous nature of the data fetching
        let expectation = expectation(description: "Async setup")
        
        Task {
            let cardItems = try await DataManager.LocalData.getMockedCardItems()
            let cardItem = cardItems[2] // Using 3rd book
            sut = CardCellView.ViewModel(item: cardItem)
            expectation.fulfill() // Notify that async setup is done
        }
        
        // Wait for the async operation to complete before continuing with the test
        waitForExpectations(timeout: 5.0)
  
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_cellTitlePropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.cellTitle, "Ampharos", "values should be equal")
    }
    
    func test_cellCornerRadiusPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.cornerRadius, 10.0, "values should be equal")
    }
    
    func test_backgroundColorPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.backgroundColor, UIColor(named: "BackgroundColor"), "values should be equal")
    }
    
    func test_textColorPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.textColor, UIColor.white, "values should be equal")
    }
    
    func test_fontPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.font, UIFont.systemFont(ofSize: 18, weight: .heavy), "values should be equal")
    }
    
}

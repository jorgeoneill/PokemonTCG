//
//  Card.swift
//  PokemonTCG
//
//  Created by Jorge O'Neill on 27/02/2025.
//

import XCTest
@testable import PokemonTCG

final class CardDetailViewModelTests: XCTestCase {
    
    // System under test property
    var sut: CardDetailView.ViewModel?
    
    override func setUpWithError() throws {
        // Expectation needs to be set and awaited for fullfilment, because of the asynchronous nature of the data fetching
        let expectation = expectation(description: "Async setup")
        
        Task {
            let card = try await DataManager.LocalData.getMockedCard()
            sut = CardDetailView.ViewModel(card: card)
            expectation.fulfill() // Notify that async setup is done
        }
        
        // Wait for the async operation to complete before continuing with the test
        waitForExpectations(timeout: 5.0)
  
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_cardNamePropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.cardName, "Furret", "values should be equal")
    }
    
    func test_imageURLPropertyIsSetCorrectly_onStart() throws {
        guard let testUrl = URL(string: "https://assets.tcgdex.net/en/swsh/swsh3/136/high.png") else { return }
        
        XCTAssertEqual(sut?.imageURL, testUrl, "values should be equal")
    }
    
    func test_illustratorPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.illustrator, "Illustrator: tetsuya koizumi", "values should be equal")
    }
    
    func test_rarityPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.rarity, "Rarity: Uncommon", "values should be equal")
    }
    
    func test_setNamePropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.setName, "Set: Darkness Ablaze", "values should be equal")
    }
    
    func test_hpPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.hp, "110 HP", "values should be equal")
    }
    
    func test_typesPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.types, "Type: Colorless", "values should be equal")
    }
    
    func test_evolveFromPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.evolveFrom, "Evolves from: Sentret", "values should be equal")
    }
    
    func test_stagePropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.stage, "Stage: Stage1", "values should be equal")
    }
    
    func test_descriptionPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.description, "It makes a nest to suit its long and skinny body. The nest is impossible for other Pokémon to enter.")
    }
    
    func test_retreatCostPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.retreatCost, "Retreat Cost: 1", "values should be equal")
    }
    
    func test_regulationMarkPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.regulationMark, "Regulation Mark: D", "values should be equal")
    }
    
    func test_legalitiesPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.legalities, "Legalities: Expanded", "values should be equal")
    }
    
    func test_lastUpdatedPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.lastUpdated, "Last updated on 17 Jun 2024", "values should be equal")
    }
    
    func test_attacksArrayIsNotEmpty_onStart() throws {
        XCTAssertFalse(sut?.attacks.isEmpty ?? true, "Attacks should not be empty")
    }
    
    func test_firstAttackNameIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.attacks.first?.name, "Feelin\' Fine", "First attack name should be correct")
    }
    
    func test_firstAttackEffectIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.attacks.first?.effect, "Draw 3 cards.", "First attack effect should be correct")
    }
    
    func test_firstAttackDamageIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.attacks.first?.damage, "??", "First attack damage should be correct")
    }
    
    func test_firstAttackCostIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.attacks.first?.cost, "Colorless", "First attack cost should be correct")
    }
    
    func test_weaknessesArrayIsNotEmpty_onStart() throws {
        XCTAssertFalse(sut?.weaknesses.isEmpty ?? true, "Weaknesses should not be empty")
    }
    
    func test_firstWeaknessTypeIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.weaknesses.first?.type, "Fighting", "First weakness type should be correct")
    }
    
    func test_firstWeaknessValueIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.weaknesses.first?.value, "×2", "First weakness value should be correct")
    }
    
    func test_cardCornerRadiusPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.cardCornerRadius, 10.0, "values should be equal")
    }
    
    func test_backgroundColorPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.backgroundColor, UIColor.systemBackground, "values should be equal")
    }
    
    func test_textColorPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.textColor, UIColor(named: "TextColor"), "values should be equal")
    }
    
    func test_mainFontPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.mainFont, UIFont.systemFont(ofSize: 16, weight: .regular), "values should be equal")
    }
    
    func test_titleFontPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.titleFont, UIFont.systemFont(ofSize: 22, weight: .black), "values should be equal")
    }
    
    func test_subtitleFontPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.subtitleFont, UIFont.systemFont(ofSize: 18, weight: .bold), "values should be equal")
    }
    
    func test_descriptionFontPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.descriptionFont, UIFont.systemFont(ofSize: 16, weight: .thin), "values should be equal")
    }
    
    func test_footerFontFontPropertyIsSetCorrectly_onStart() throws {
        XCTAssertEqual(sut?.footerFont, UIFont.systemFont(ofSize: 14, weight: .thin), "values should be equal")
    }
}

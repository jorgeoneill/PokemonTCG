//
//  MainView+ViewModel.swift
//  PokemonTCG
//
//  Created by Jorge O'Neill on 24/02/2025.
//

import UIKit

extension MainView {
    final class ViewModel {
        // MARK: - Private properties
        private var allCards: [Card] = []
        private var filteredCards: [Card] = []
        private var isSearching: Bool = false
        private var displayedCards: [Card] {
            filteredCards.isEmpty && !isSearching ? allCards : filteredCards
        }

        // MARK: - Public properties
        var numberOfCards: Int {
            displayedCards.count
        }
        var onDataUpdated: (() -> Void)?
        let emptyListMessage = String(localized: "main_view_empty_list_message")
        let emptyListMessageColor = Constants.UI.emptyListMessageColor
        let emptyListMessageFont = Constants.UI.emptyListMessageFont
        let searchBarPlaceholder = String(localized: "search_placeholder")

        // MARK: - Public methods
        func cardCellViewModel(at index: Int) -> CardCellView.ViewModel {
            CardCellView.ViewModel(card: displayedCards[index])
        }
        
        func card(at index: Int) -> Card? {
            guard index >= 0 && index < numberOfCards else {
                print("Index \(index) out of bounds for allCards array.")
                return nil
            }
            return displayedCards[index]
        }

        func getCards() async throws {
            // Uncomment below to use mocked data
            allCards = try await DataManager.NetworkData.getCards()
            //allCards = try await DataManager.LocalData.getMockedCards()
            filteredCards = [] // Clear any previous filtering

            // Notify the view that data is updated
            onDataUpdated?()
        }
        
        func searchCards(with query: String) {
            isSearching = !query.isEmpty
            filteredCards = query.isEmpty ? [] : allCards.filter { $0.name.localizedCaseInsensitiveContains(query) }
            onDataUpdated?()
        }
    }
}


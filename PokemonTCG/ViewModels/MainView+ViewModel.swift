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
        private var allItems: [CardListItem] = []
        private var filteredItems: [CardListItem] = []
        private var isSearching: Bool = false
        private var displayedItems: [CardListItem] {
            filteredItems.isEmpty && !isSearching ? allItems : filteredItems
        }
        var onCardSelected: ((CardListItem) -> Void)?

        // MARK: - Public properties
        var numberOfItems: Int {
            displayedItems.count
        }
        var onDataUpdated: (() -> Void)?
        let emptyListMessage = String(localized: "main_view_empty_list_message")
        let emptyListMessageColor = Constants.UI.emptyListMessageColor
        let emptyListMessageFont = Constants.UI.emptyListMessageFont
        let searchBarPlaceholder = String(localized: "search_placeholder")

        // MARK: - Public methods
        func cardCellViewModel(at index: Int) -> CardCellView.ViewModel {
            CardCellView.ViewModel(item: displayedItems[index])
        }
        
        func card(at index: Int) -> CardListItem? {
            guard index >= 0 && index < numberOfItems else {
                print("Index \(index) out of bounds for displayedItems array.")
                return nil
            }
            return displayedItems[index]
        }

        func getCardItems() async throws {
            // Uncomment below to use mocked data
            allItems = try await DataManager.NetworkData.getCardItems()
            //allItems = try await DataManager.LocalData.getMockedCardItems()
            filteredItems = [] // Clear any previous filtering

            // Notify the view that data is updated
            onDataUpdated?()
        }
        
        func searchItems(with query: String) {
            isSearching = !query.isEmpty
            filteredItems = query.isEmpty ? [] : allItems.filter { $0.name.localizedCaseInsensitiveContains(query) }
            onDataUpdated?()
        }
    }
}


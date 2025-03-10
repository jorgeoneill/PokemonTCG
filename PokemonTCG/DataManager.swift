//
//  DataManager.swift
//  PokemonTCG
//
//  Created by Jorge O'Neill on 23/02/2025.
//

import UIKit

enum DataManager {
    // MARK: - Properties
    private static let imageCache = NSCache<NSString, UIImage>()
    
    enum NetworkData {
        // MARK: public methods
        // Get list of card items
        static func getCardItems() async throws -> [CardListItem] {
            // Step 1: Load cached data first (for instant UI update)
            if let cachedItems = LocalData.loadCardItems() {
                print("[DataManager] \(cachedItems.count) card items retrieved from cache.")
                
                // Fetch fresh data in the background and save it in cache
                Task {
                    do {
                        let freshItems = try await fetchCardItems()
                        LocalData.cache(cardItems: freshItems)
                    } catch {
                        print("[DataManager] Failed to refresh card items: \(error).")
                    }
                }
                
                return cachedItems
            }
            
            // Step 2: If no cache, fetch fresh data immediately
            let freshItems = try await fetchCardItems()
            LocalData.cache(cardItems: freshItems)
            return freshItems
        }
        // Get single card detail
        static func getCard(for cardId: String) async throws -> Card {
            guard let url = endpoint(for: cardId) else {
                throw NetworkError.invalidURL
            }
            
            let card: Card = try await request(url: url)
            return card
        }
        
        static func getImage(from url: URL?) async throws -> UIImage {
            guard let url else {
                throw NetworkError.invalidURL
            }
            
            // Used as the key for cache storage
            let cacheKey = url.absoluteString as NSString
            
            // Return image from cache if available
            if let cachedImage = imageCache.object(forKey: cacheKey) {
                print("[DataManager] image retrieved from cache: \(cacheKey).")
                return cachedImage
            }
            
            // Return image from network if available and save it to cache
            let image = try await fetchImage(from: url)
            print("[DataManager] image retrieved form network: \(url).")
            imageCache.setObject(image, forKey: cacheKey)
            return image
            
        }
        
        // MARK: private methods
        private static func fetchCardItems() async throws -> [CardListItem] {
            guard let url = endpoint() else {
                throw NetworkError.invalidURL
            }

            let cardItems: [CardListItem] = try await request(url: url)
            print("[DataManager] \(cardItems.count) card items retrieved from network.")
            return cardItems
        }
        
        // Generic network data request
        private static func request<T: Decodable>(url: URL) async throws -> T {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            else {
                throw NetworkError.invalidServerResponse
            }
            
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return decodedObject
        }
        
        static func fetchImage(from url: URL?) async throws -> UIImage {
            guard let url else {
                throw NetworkError.invalidURL
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            else {
                throw NetworkError.invalidServerResponse
            }
            
            guard let image = UIImage(data: data) else {
                throw NetworkError.invalidImageData
            }
            
            return image
        }
        
        
        // MARK: - Enpoint creation
        static func endpoint(for cardId: String? = nil) -> URL? {
            var components = URLComponents()
            components.scheme = Constants.API.URL.scheme
            components.host = Constants.API.URL.host
            components.path = Constants.API.URL.path
            let url = components.url
            //print("[DataManager] Fetching cards from: \(String(describing: url))")
            if let cardId {
                return url?.appendingPathComponent(cardId)
            }
            return url
        }
    }
    
    
    enum LocalData {
        // Load cached card items
        static func loadCardItems() -> [CardListItem]? {
            guard let data = UserDefaults.standard.data(forKey: Constants.UserDefaultsKeys.cachedCardItems) else { return nil }
            return try? JSONDecoder().decode([CardListItem].self, from: data)
        }
        
        // Save card items to cache
        static func cache(cardItems: [CardListItem]) {
            guard let data = try? JSONEncoder().encode(cardItems) else { return }
           
            UserDefaults.standard.setValue(data, forKey: Constants.UserDefaultsKeys.cachedCardItems)
            print("[DataManager] \(cardItems.count) card items cached.")
        }
        
        // Helper function to clear image cache if necessary
        static func clearImageCache() {
            imageCache.removeAllObjects()
        }
        
        // Helper function to clear card items cache if necessary
        static func clearCardsCache() {
            UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKeys.cachedCardItems)
            UserDefaults.standard.synchronize()
        }
        
        // Mocked data
        static func getMockedCardItems() async throws -> [CardListItem] {
            guard let url = Bundle.main.url(forResource: "card_items_small", withExtension: "json"
            ) else {
                throw NetworkError.invalidURL
            }
            
            let data = try Data(contentsOf: url)
            let items: [CardListItem] = try JSONDecoder().decode(
                [CardListItem].self,
                from: data
            )
            print("[DataManager] \(items.count) card items retrieved from mocked API.")
            return items
        }
        
        static func getMockedCard() async throws -> Card {
            guard let url = Bundle.main.url(forResource: "card", withExtension: "json"
            ) else {
                throw NetworkError.invalidURL
            }
            
            let data = try Data(contentsOf: url)
            let card: Card = try JSONDecoder().decode(
                Card.self,
                from: data
            )
            print("[DataManager] \(card.name ?? "Unknown") card retrieved from mocked API.")
            return card
        }
    }
}

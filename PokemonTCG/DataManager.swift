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
        
        static func getCards() async throws -> [Card] {
            // Step 1: Load cached data first (for instant UI update)
            if let cachedCards = LocalData.loadCards() {
                print("[DataManager] \(cachedCards.count) cards retrieved from cache.")
                
                // Fetch fresh data in the background and save it in cache
                Task {
                    do {
                        let freshCards = try await fetchCards()
                        LocalData.cache(cards: freshCards)
                    } catch {
                        print("[DataManager] Failed to refresh cards: \(error).")
                    }
                }
                
                return cachedCards
            }
            
            // Step 2: If no cache, fetch fresh data immediately
            let freshCards = try await fetchCards()
            LocalData.cache(cards: freshCards)
            return freshCards
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
        private static func fetchCards() async throws -> [Card] {
            guard let url = endpoint() else {
                throw NetworkError.invalidURL
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            else {
                throw NetworkError.invalidServerResponse
            }
            
            let cards: [Card] = try JSONDecoder().decode(
                [Card].self,
                from: data
            )
            
            print("[DataManager] \(cards.count) cards retrieved from network.")
            return cards
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
        static func endpoint() -> URL? {
            var components = URLComponents()
            components.scheme = Constants.API.URL.scheme
            components.host = Constants.API.URL.host
            components.path = Constants.API.URL.path
            let url = components.url
            //print("[DataManager] Fetching cards from: \(String(describing: url))")
            return url
        }
    }
    
    
    enum LocalData {
        // Load cached cards
        static func loadCards() -> [Card]? {
            guard let data = UserDefaults.standard.data(forKey: Constants.UserDefaultsKeys.cachedCards) else { return nil }
            return try? JSONDecoder().decode([Card].self, from: data)
        }
        
        // Save cards to cache
        static func cache(cards: [Card]) {
            if let data = try? JSONEncoder().encode(cards) {
                UserDefaults.standard.setValue(data, forKey: Constants.UserDefaultsKeys.cachedCards)
                print("[DataManager] \(cards.count) cards cached.")
            }
        }
        
        // Helper function to clear image cache if necessary
        static func clearImageCache() {
            imageCache.removeAllObjects()
        }
        
        // Helper function to clear cards cache if necessary
        static func clearCardsCache() {
            UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKeys.cachedCards)
            UserDefaults.standard.synchronize()
        }
        
        // Mocked data
        static func getMockedCards() async throws -> [Card] {
            guard let url = Bundle.main.url(forResource: "cards", withExtension: "json"
            ) else {
                throw NetworkError.invalidURL
            }
            
            let data = try Data(contentsOf: url)
            let cards: [Card] = try JSONDecoder().decode(
                [Card].self,
                from: data
            )
            print("[DataManager] \(cards.count) cards retrieved from mocked API.")
            return cards
        }
    }
}

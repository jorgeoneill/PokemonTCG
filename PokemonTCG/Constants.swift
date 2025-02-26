//
//  Constants.swift
//  PokemonTCG
//
//  Created by Jorge O'Neill on 23/02/2025.
//

import UIKit

enum Constants {
    enum API {
        enum URL {
            static let scheme = "https"
            static let host = "api.tcgdex.net"
            static let path = "/v2/en/cards"

            enum Image {
                static let lowQuality = "low"
                static let highQuality = "high"
                static let pngExtension = "png"
            }
        }
    }
    
    enum UI {
        // Main view
        static let emptyListMessageColor = UIColor.gray // Works well on light/dark modes
        static let emptyListMessageFont = UIFont.systemFont(ofSize: 18, weight: .bold)
        // Card cell view
        static let cardCellViewIdentifier = "CardCell"
        static let cardCellViewHeight: CGFloat = 100.0
        static let cardCellCornerRadius: CGFloat = 10.0
        // Custom background color adapts to light/dark apperances
        static let cardCellBackgroundColor = UIColor(named: "BackgroundColor")
        static let cardCellTextColor = UIColor.white
        static let cardCellFont = UIFont.systemFont(ofSize: 18, weight: .heavy)
    }
    
    enum UserDefaultsKeys {
        static let cachedCards = "cachedCards"
    }
}


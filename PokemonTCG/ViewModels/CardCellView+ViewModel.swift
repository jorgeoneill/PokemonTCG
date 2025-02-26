//
//  CardCellView+ViewModel.swift
//  PokemonTCG
//
//  Created by Jorge O'Neill on 24/02/2025.
//

import UIKit

extension CardCellView {
    final class ViewModel {
        // MARK: - Private properties
        private let card: Card
        private var cardImage: UIImage?
        private var imageURL: URL? {
            guard let imageBaseURLString = card.imageBaseURLString else {
                return nil
            }
            let imageBaseURL = URL(string: imageBaseURLString)
            let urlSuffix = Constants.API.URL.Image.lowQuality + "." + Constants.API.URL.Image.pngExtension
            
            return imageBaseURL?.appendingPathComponent(urlSuffix)
        }
        
        // MARK: - Public properties
        var cellTitle: String {
            card.name
        }
        var cornerRadius: CGFloat {
            Constants.UI.cardCellCornerRadius
        }
        var backgroundColor: UIColor {
            Constants.UI.cardCellBackgroundColor ?? UIColor.gray
        }
        var textColor: UIColor {
            Constants.UI.cardCellTextColor
        }
        var font: UIFont {
            Constants.UI.cardCellFont
        }
        
        // MARK: - Lifecycle
        init(card: Card) {
            self.card = card
        }
        
        // MARK: - Public methods
        func getCardImage() async -> UIImage? {
            guard let url = imageURL else {
                return nil
            }
            
            do {
                cardImage = try await DataManager.NetworkData.getImage(from: url)
                return cardImage
            } catch {
                print("[CardCellView.ViewModel] Failed to fetch image: \(error).")
                return nil
            }
        }
    }
}

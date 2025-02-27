//
//  CardDetailView+ViewModel.swift
//  PokemonTCG
//
//  Created by Jorge O'Neill on 26/02/2025.
//

import UIKit

extension CardDetailView {
    final class ViewModel {
        private let card: Card

        // MARK: - Computed Properties
        var cardName: String { card.name ?? String(localized: "unknown_card_name") }

        var imageURL: URL? {
            guard let imageBaseURLString = card.image else { return nil }
            let imageBaseURL = URL(string: imageBaseURLString)
            let urlSuffix = Constants.API.URL.Image.highQuality + "." + Constants.API.URL.Image.pngExtension
            return imageBaseURL?.appendingPathComponent(urlSuffix)
        }

        var illustrator: String {
            String(localized: "illustrator_label") + ": \(card.illustrator ?? String(localized: "illustrator_label_default_value"))"
        }

        var rarity: String {
            String(localized: "rarity_label") + ": \(card.rarity ?? String(localized: "illustrator_label_default_value"))"
        }

        var setName: String {
            String(localized: "set_label") + ": \(card.set?.name ?? String(localized: "set_label_default_value"))"
        }

        var setSymbolURL: URL? {
            guard let symbol = card.set?.symbol else { return nil }
            return URL(string: symbol)
        }

        var hp: String {
            String(localized: "hp_label") + ": \(card.hp ?? 0)"
        }

        var types: String {
            String(localized: "type_label") + ": \(card.types?.joined(separator: ", ") ?? String(localized: "type_label_default_value"))"
        }

        var evolveFrom: String {
            card.evolveFrom?.isEmpty ?? true
                ? String(localized: "n_a")
                : String(localized: "evolves_from_label") + ": \(card.evolveFrom ?? String(localized: "evolves_from_label_default_value"))"
        }

        var description: String {
            card.description ?? String(localized: "description_label_default_value")
        }

        var stage: String {
            String(localized: "stage_label") + ": \(card.stage ?? String(localized: "stage_label_default_value"))"
        }

        var attacks: [AttackViewModel] {
            card.attacks?.map { AttackViewModel(attack: $0) } ?? []
        }

        var weaknesses: [WeaknessViewModel] {
            card.weaknesses?.map { WeaknessViewModel(weakness: $0) } ?? []
        }

        var retreatCost: String {
            String(localized: "retreat_cost_label") + ": \(card.retreat ?? 0)"
        }

        var regulationMark: String {
            String(localized: "regulation_mark_label") + ": \(card.regulationMark ?? String(localized: "regulation_mark_label_default_value"))"
        }

        var legalities: String {
            String(localized: "legalities_label") + ": \(legalStatus)"
        }

        var lastUpdated: String {
            String(localized: "updated_label") + " \(formattedDate)"
        }
        var cardCornerRadius: CGFloat {
            Constants.UI.cardCornerRadius
        }
        
        var backgroundColor: UIColor {
            UIColor.systemBackground
        }
        var textColor: UIColor {
            Constants.UI.detailViewTextColor
        }
        var mainFont: UIFont {
            Constants.UI.detailViewMainFont
        }
        var titleFont: UIFont {
            Constants.UI.detailViewTitleFont
        }
        var subtitleFont: UIFont {
            Constants.UI.detailViewSubtitleFont
        }
        var descriptionFont: UIFont {
            Constants.UI.detailViewDescriptionFont
        }
        var footerFont: UIFont {
            Constants.UI.footerFont
        }

  
        
        // MARK: - Helper (private) Computed Properties
        private var legalStatus: String {
            var statuses: [String] = []
            if card.legal?.standard ?? false { statuses.append(String(localized: "legal_status_label_standard_value")) }
            if card.legal?.expanded ?? false { statuses.append(String(localized: "legal_status_label_expanded_value")) }
            return statuses.isEmpty ? String(localized: "legal_status_label_none_value") : statuses.joined(separator: ", ")
        }

        private var formattedDate: String {
            let dateFormatter = ISO8601DateFormatter()
            guard let date = dateFormatter.date(from: card.updated ?? "") else {
                return card.updated ?? String(localized: "date_label_default_value")
            }
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateStyle = .medium
            return outputFormatter.string(from: date)
        }
        
        // MARK: - Lifecycle
        init(card: Card) {
            self.card = card
        }
    }
}

// MARK: - Attack ViewModel
extension CardDetailView.ViewModel {
    struct AttackViewModel {
        let name: String
        let effect: String
        let damage: String
        let cost: String

        init(attack: Card.Attack) {
            self.name = attack.name ?? String(localized: "attacks_label_unknown_attack_value")
            self.effect = attack.effect ?? String(localized: "attacks_label_no_effect_value")
            self.damage = "??" // Incorrect network data, sometimes an Int, sometimes a String.
            self.cost = attack.cost?.joined(separator: ", ") ?? String(localized: "attacks_label_no_cost_value")
        }
    }
}

// MARK: - Weakness ViewModel
extension CardDetailView.ViewModel {
    struct WeaknessViewModel {
        let type: String
        let value: String

        init(weakness: Card.Weekness) {
            self.type = weakness.type ?? String(localized: "weakness_label_unknown_type_value")
            self.value = weakness.value ?? String(localized: "weakness_label_no_weakness_value")
        }
    }
}

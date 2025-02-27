//
//  Card.swift
//  PokemonTCG
//
//  Created by Jorge O'Neill on 26/02/2025.
//

struct Card: Decodable {
    var category: String?
    var id: String?
    var illustrator: String?
    var image: String?
    var localId: String?
    var name: String?
    var rarity: String?
    var set: Set?
    var variants: Variants?
    var dexId: [Int]?
    var hp: Int?
    var types: [String]?
    var evolveFrom: String?
    var description: String?
    var stage: String?
    var attacks: [Attack]?
    var weaknesses: [Weekness]?
    var retreat: Int?
    var regulationMark: String?
    var legal: Legal?
    var updated: String?

        
    struct Set: Decodable {
        var cardCount: CardCount?
        var id: String?
        var logo: String?
        var name: String?
        var symbol: String?
        
        struct CardCount: Decodable {
            var official: Int?
            var total: Int?
        }
    }
    
    struct Variants: Decodable {
        var firstEdition : Bool?
        var holo : Bool?
        var normal : Bool?
        var reverse : Bool?
        var wPromo : Bool?
    }
    
    struct Attack: Decodable {
        var cost: [String]?
        var name: String?
        var effect: String?
       // var damage: Int?  Incorrect network data, sometimes an Int, sometimes a String. Not being used.

    }
    
    struct Weekness: Decodable {
        var type: String?
        var value: String?
    }
    
    struct Legal: Decodable {
        var standard : Bool?
        var expanded : Bool
    }
}

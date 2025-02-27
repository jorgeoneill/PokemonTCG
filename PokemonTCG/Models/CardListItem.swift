//
//  CardListItem.swift
//  PokemonTCG
//
//  Created by Jorge O'Neill on 23/02/2025.
//

// Using Codable instead of just Decodable to enable caching
struct CardListItem: Codable {
    let id: String
    let localId: String
    let name: String
    let imageBaseURLString: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case localId
        case name
        case imageBaseURLString = "image"
    }
}

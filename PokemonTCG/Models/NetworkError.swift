//
//  NetworkError.swift
//  PokemonTCG
//
//  Created by Jorge O'Neill on 23/02/2025.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidServerResponse
    case invalidImageData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            String(localized: "error_message_invalid_url")
        case .invalidServerResponse:
            String(localized: "error_message_invalid_server_response")
        case .invalidImageData:
            String(localized: "error_message_invalid_image_data")
        }
    }
}

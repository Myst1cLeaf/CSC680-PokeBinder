//
//  CardDataManager.swift
//  PokeBinder
//
//  Created by Luis Carrillo on 3/26/25.
//

import Foundation

struct PokemonCard: Codable, Identifiable {
    let id: String
    let name: String
    let supertype: String
    let types: [String]?
    let rarity: String?
    let images: CardImages

    struct CardImages: Codable {
        let small: String
        let large: String
    }
}

struct CardDataManager {
    static func loadCards() -> [PokemonCard] {
        guard let url = Bundle.main.url(forResource: "pokemon_cards", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let cards = try? JSONDecoder().decode([PokemonCard].self, from: data) else {
            print("Failed to load cards from JSON")
            return []
        }

        return cards
    }
}

func loadCards() -> [PokemonCard] {
    if let url = Bundle.main.url(forResource: "pokemon_cards", withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode([PokemonCard].self, from: data)
            return decodedData
        } catch {
            print("Error loading JSON: \(error)")
        }
    }
    return []
}

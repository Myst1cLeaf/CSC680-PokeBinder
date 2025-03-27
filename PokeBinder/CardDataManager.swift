//
//  CardDataManager.swift
//  PokeBinder
//
//  Created by Luis Carrillo on 3/26/25.
//

import Foundation

struct PokemonCard: Codable {
    let name: String
    let type: String
    let rarity: String
    let image_url: String
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

//
//  CardStorageManager.swift
//  PokeBinder
//
//  Created by Luis Carrillo on 4/22/25.
//
import Foundation

class CardStorageManager {
    private static let savedCardsKey = "savedCards"

    // Save a card
    static func saveCard(_ card: PokemonCard) {
        var savedCards = loadSavedCards()
        
        // Prevent duplicates
        if !savedCards.contains(where: { $0.id == card.id }) {
            savedCards.append(card)
            if let encoded = try? JSONEncoder().encode(savedCards) {
                UserDefaults.standard.set(encoded, forKey: savedCardsKey)
            }
        }
    }

    // Load saved cards
    static func loadSavedCards() -> [PokemonCard] {
        if let data = UserDefaults.standard.data(forKey: savedCardsKey),
           let decodedCards = try? JSONDecoder().decode([PokemonCard].self, from: data) {
            return decodedCards
        }
        return []
    }

    // Remove a saved card
    static func removeCard(_ card: PokemonCard) {
        var savedCards = loadSavedCards()
        savedCards.removeAll { $0.id == card.id }
        if let encoded = try? JSONEncoder().encode(savedCards) {
            UserDefaults.standard.set(encoded, forKey: savedCardsKey)
        }
    }
}

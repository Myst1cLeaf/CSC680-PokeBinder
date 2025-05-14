//
//  SavedCardsManager.swift
//  PokeBinder
//
//  Created by Luis Carrillo on 4/29/25.
//

import Foundation

class SavedCardsManager: ObservableObject {
    @Published var savedCards: [PokemonCard] = []

    static let shared = SavedCardsManager()

    private init() {
        // Initialize with loaded saved cards from storage
        self.savedCards = CardStorageManager.loadSavedCards()
    }

    func saveCard(_ card: PokemonCard) {
        // Check if the card with the same id already exists
        if !savedCards.contains(where: { $0.id == card.id }) {
            // Add card to saved cards and update storage
            savedCards.append(card)
            CardStorageManager.saveCard(card)
        } else {
            print("Card with id \(card.id) is already saved.")
        }
    }

    func removeCard(_ card: PokemonCard) {
        // Remove card from saved cards and update the storage
        if let index = savedCards.firstIndex(where: { $0.id == card.id }) {
            savedCards.remove(at: index)
            CardStorageManager.removeCard(card)
        } else {
            print("Card with id \(card.id) not found.")
        }
    }
}

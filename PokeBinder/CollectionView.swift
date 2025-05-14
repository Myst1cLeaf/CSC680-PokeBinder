//
//  CollectionView.swift
//  PokeBinder
//
//  Created by Luis Carrillo on 4/23/25.
//

import SwiftUI

struct CollectionView: View {
    @State private var savedCards: [PokemonCard] = []

    var body: some View {
        VStack {
            Text("Saved Cards")
                .font(.largeTitle)
                .padding(.top, 20)
                .padding(.bottom, 10)

            List(savedCards, id: \.id) { card in
                HStack {
                    // Card image
                    AsyncImage(url: URL(string: card.images.small)) { image in
                        image.resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.trailing, 10)

                    VStack(alignment: .leading, spacing: 5) {
                        Text(card.name)
                            .font(.headline)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Text(card.types?.joined(separator: ", ") ?? "Unknown type")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Text("ID: \(card.id)")  // Optional: show ID to confirm uniqueness
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    // Remove Button
                    Button(action: {
                        CardStorageManager.removeCard(card)
                        savedCards = CardStorageManager.loadSavedCards()
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .padding(5)
                            .background(Color.white.opacity(0.6))
                            .clipShape(Circle())
                    }
                    .padding(.leading, 10)
                }
                .padding(.vertical, 10)  // Add vertical padding between rows
                Divider() // Divider between items
            }
            .padding(.horizontal, 10) // Add horizontal padding around the list
        }
        .onAppear {
            savedCards = CardStorageManager.loadSavedCards()
        }
    }
}






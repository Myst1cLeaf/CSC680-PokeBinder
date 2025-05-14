//
//  ContentView.swift
//  PokeBinder
//
//  Created by Luis Carrillo on 3/24/25.
//

import SwiftUI

struct SearchView: View {
    @State private var cardName: String = ""
    @State private var cardNumber: String = ""
    @State private var searchResults: [PokemonCard] = []

    @State private var scannedName: String = ""
    @State private var showScanner = false

    @State private var capturedImage: UIImage?
    @State private var showCamera = false

    @ObservedObject var savedCardsManager = SavedCardsManager.shared // Use shared manager

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("Enter Pokémon Card Name", text: $cardName)
                    .padding(12)
                    .background(Color.white)
                    .foregroundColor(.black) // Ensures text inside is dark
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .padding(.horizontal)


                Button(action: searchCard) {
                    Text("Search")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Button(action: { showCamera = true }) {
                    Label("Take Photo of Card", systemImage: "camera")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .sheet(isPresented: $showCamera, onDismiss: processImage) {
                    CameraCaptureView(image: $capturedImage)
                }

                NavigationLink(destination: CollectionView()) {
                    Text("View Saved Cards")
                        .font(.subheadline)
                        .padding(.top, 4)
                }

                List {
                    ForEach(searchResults, id: \.id) { card in
                        CardRowView(card: card, savedCardsManager: savedCardsManager)
                    }
                }

            }
            .navigationTitle("Card Lookup")
            .padding()
            .onAppear {
                savedCardsManager.savedCards = CardStorageManager.loadSavedCards()
            }
        }
    }

    func searchCard() {
        print("🔍 Searching for name: '\(cardName)', number: '\(cardNumber)'")
        
        CardAPIService.shared.searchCards(name: cardName, cardNumber: cardNumber) { cards in
            DispatchQueue.main.async {
                self.searchResults = cards
            }
        }
    }

    func processImage() {
        guard let image = capturedImage else { return }

        TextRecognizer.recognizeText(from: image) { fullText in
            DispatchQueue.main.async {
                guard let fullText = fullText else {
                    print("❌ No text found.")
                    return
                }

                let lines = fullText.components(separatedBy: .newlines)
                let name = lines.first(where: { TextRecognizer.isProbableCardName($0) }) ?? ""
                let number = TextRecognizer.extractCardNumber(from: lines) ?? ""

                self.cardName = name
                self.cardNumber = number
                self.searchCard()
            }
        }
    }
}

extension View {
    func cardStyle() -> some View {
        self
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.8)))
            .shadow(radius: 4)
            .padding(.horizontal)
            .padding(.vertical, 4)
    }
}


//
//  ContentView.swift
//  PokeBinder
//
//  Created by Luis Carrillo on 3/24/25.
//

import SwiftUI

struct SearchView: View {
    @State private var cardName: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter Pokemon Card Name", text: $cardName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                searchCard()
            }) {
                Text("Search")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            // Display Search Results
            List(searchResults, id: \.name) { card in
                HStack {
                    // Load image from URL
                    AsyncImage(url: URL(string: card.image_url)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                    VStack(alignment: .leading) {
                        Text(card.name).font(.headline)
                        Text(card.type).font(.subheadline).foregroundColor(.gray)
                    }
                }
            }
        }
        .padding()
    }
    
    @State private var searchResults: [PokemonCard] = []
    
    func searchCard() {
        let allCards = loadCards()
        searchResults = allCards.filter{$0.name.lowercased().contains(cardName.lowercased())}
        print("Searching for: \(cardName)")
    }
    
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

#Preview {
    SearchView()
}

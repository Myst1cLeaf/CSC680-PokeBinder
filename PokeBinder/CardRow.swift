import SwiftUI

struct CardRowView: View {
    let card: PokemonCard
    @ObservedObject var savedCardsManager: SavedCardsManager

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: card.images.small)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading) {
                Text(card.name).font(.headline)
                Text(card.types?.joined(separator: ", ") ?? "Unknown type")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Button(action: {
                print("🔁 Tapped heart for card: \(card.name), ID: \(card.id)")

                if savedCardsManager.savedCards.contains(where: { $0.id == card.id }) {
                    savedCardsManager.removeCard(card)
                } else {
                    savedCardsManager.saveCard(card)
                }
            }) {
                Image(systemName: savedCardsManager.savedCards.contains(where: { $0.id == card.id }) ? "heart.fill" : "heart")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 4)
    }
}

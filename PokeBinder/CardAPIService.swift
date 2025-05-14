//
//  CardAPIService.swift
//  PokeBinder
//
//  Created by Luis Carrillo on 4/23/25.
//
import Foundation

class CardAPIService {
    static let shared = CardAPIService()
    private let baseURL = "https://api.pokemontcg.io/v2/cards"
    private let apiKey: String = {
        Bundle.main.infoDictionary?["POKEMON_API_KEY"] as? String ?? ""
    }()

    func searchCards(name: String, cardNumber: String?, completion: @escaping ([PokemonCard]) -> Void) {
        // Normalize the card name
        let formattedName = name
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "’", with: "'") // Normalize apostrophes

        // Start building the query components
        var queryComponents: [String] = []

        if !formattedName.isEmpty {
            // Wrap in quotes in case name contains spaces or special characters
            queryComponents.append("name:\"\(formattedName)\"")
        }

        if let cardNumber = cardNumber, !cardNumber.isEmpty {
            let numberOnly = cardNumber.split(separator: "/").first?.trimmingCharacters(in: .whitespacesAndNewlines).trimmingLeadingZeros() ?? ""

            queryComponents.append("number:\(numberOnly)")
        }

        let query = queryComponents.joined(separator: " AND ")


        // Encode the query for use in the URL
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)?q=\(encodedQuery)") else {
            print("❌ Failed to encode query or build URL. Query: \(query)")
            completion([])
            return
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // Log the query and URL for debugging
        print("🔍 Request URL: \(url)")

        // Perform the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("🔍 Raw API Response: \(jsonString)")
                }

                do {
                    let decoded = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(decoded.data)
                } catch {
                    print("🛠️ Decoding error: \(error)")
                    completion([])
                }
            } else {
                print("🚨 API error: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
            }
        }.resume()
    }

    private struct APIResponse: Codable {
        let data: [PokemonCard]
    }
    
}

extension String {
    func trimmingLeadingZeros() -> String {
        return String(self.drop { $0 == "0" })
    }
}


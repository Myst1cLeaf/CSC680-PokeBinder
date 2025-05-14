//
//  TextRecognizer.swift
//  PokeBinder
//
//  Created by Luis Carrillo on 4/23/25.
//

import Vision
import UIKit

struct TextRecognizer {
    static func recognizeText(from image: UIImage, completion: @escaping (String?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }

        let request = VNRecognizeTextRequest { request, error in
            guard error == nil else {
                print("❌ Text recognition error: \(error!.localizedDescription)")
                completion(nil)
                return
            }

            let observations = request.results as? [VNRecognizedTextObservation] ?? []
            let lines = observations.compactMap { $0.topCandidates(1).first?.string }

            print("🔍 All recognized lines: \(lines)")

            // Combine all recognized lines into a single string
            let fullText = lines.joined(separator: "\n")
            completion(fullText)  // Return as a single string
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }

    // Customize this logic based on your actual dataset
    static func isProbableCardName(_ text: String) -> Bool {
        let lower = text.lowercased()

        // Ignore common keywords like "HP", "stage", "basic" as these are not useful for name recognition
        let ignoredKeywords = ["hp", "stage", "basic", "trainer", "supporter", "stadium", "item", "stage1", "stage2", "stage3"]
        if ignoredKeywords.contains(where: { lower.contains($0) }) {
            return false
        }

        // Only accept lines with reasonable length and no unwanted keywords
        return text.count >= 3 && text.count < 30 && !lower.contains("card")
    }

    static func extractCardNumber(from lines: [String]) -> String? {
        let pattern = #"(\d{1,3})/\d{1,3}"#
        for line in lines {
            if let match = line.range(of: pattern, options: .regularExpression) {
                let matchedString = String(line[match])
                let numberPart = matchedString.components(separatedBy: "/").first
                return numberPart?.trimmingCharacters(in: .whitespaces)
            }
        }
        return nil
    }
}



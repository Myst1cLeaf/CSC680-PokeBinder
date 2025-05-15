# CSC680
## Pokemon Card Lookup App
Members: Luis Carrillo


## Project Overview

This app allows users to manually search for Pokémon cards and retrieve details such as name, type, stats, and abilities. Users can also save cards to their personal collection. The app will fetch data from an external API or a local database to provide detailed card information.
<br/>

## Must-Have Features

Manual Search: Users can enter a Pokémon card name to retrieve details.

Card Details Display: Show card, type, and image.

User Collection Management: Users can save and remove cards from their personal collection.

Local Storage: Use UserDefaults or CoreData/Firebase depending on time to store user collections.

Clean UI: Simple, user-friendly interface for searching and viewing card details.
<br/>

## Nice-to-Have Features

OCR (Optical Character Recognition): Users can scan a card's text to search automatically.

API Integration: Fetch card details dynamically from an external API like TCGPlayer.

Collection Sorting & Filtering: Users can categorize their saved cards (e.g., by type, rarity).

Dark Mode Support: UI adapts to light and dark themes.

Share Feature: Users can share card details via social media or messaging apps.
<br/>

## Basic Wireframes

1. Home Screen (Search Page)

Search bar at the top

List of Cards 

2. Card Details Page

Displays card name, image, and type

"Add to Collection" button

3. User Collection Page

List of saved cards

Option to remove cards from collection

Sorting and filtering options (if implemented)
<br/>

## Tech Stack

Language: Swift (UIKit or SwiftUI)

Data Storage: CoreData or Firebase(if time permits)

API (Optional): TCGPlayer API

OCR (Optional): Apple Vision Framework
<br/>

## Setup Instructions

Clone the repository.

Install dependencies if needed.

Get own API key from pokemontcg.io and replace apiKey in CardAPIService.swift as needed.

Run the app on Xcode.

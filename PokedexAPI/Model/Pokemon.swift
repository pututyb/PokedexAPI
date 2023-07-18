//
//  Pokemon.swift
//  PokedexAPI
//
//  Created by Putut Yusri Bahtiar on 12/07/23.
//

import UIKit
import Foundation
import Swift

struct PokemonListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
} // API Awal.

struct Pokemon: Codable {
    let name: String
    let url: String
} // API Awal

struct PokemonDetailResponse: Codable {
    let id: Int
    let abilities: [Ability]
    let sprites: SpritesInfo
    let name: String
    let height: Int
    let types: [TypeElement]
    let weight: Int
    let stats: [Stats]
    let moves: [Move]
//    let location_area_encounters: LocationAreaEncounters
}

struct Ability: Codable {
    let ability: AbilityInfo
} // isinya [ ability ]

struct AbilityInfo: Codable {
    let name: String
    let url: String
} // isinya [ name, url ]

struct SpritesInfo: Codable {
    let back_default: String
    let front_default: String
//    let other: otherOfficialArtwork
}

struct otherOfficialArtwork: Codable {
    let front_default: String
}

//struct LocationAreaEncounters: Codable {
//    let location_area: LocationArea
//}

//struct LocationArea: Codable {
//    let name: String
//    let url: String
//}

struct TypeElement: Codable {
    let slot: Int
    let type: Species
}

struct Species: Codable {
    let name: String
    let url: String
}

struct Stats: Codable {
    let base_stat: Int
    let effort: Int
}

struct Stat: Codable {
    let name: String
    let url: String
}

struct Move: Codable {
    let move: Species
//    let version_group_details: String
}

struct PokemonImage {
    let base64Image: String

    init?(image: UIImage) {
        guard let base64 = image.base64 else {
            return nil
        }
        self.base64Image = base64
    }

    func getImage() -> UIImage? {
        return base64Image.imageFromBase64
    }
}


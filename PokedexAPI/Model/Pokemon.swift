//
//  Pokemon.swift
//  PokedexAPI
//
//  Created by Putut Yusri Bahtiar on 12/07/23.
//

import Foundation

struct PokemonListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
}

struct Pokemon: Codable {
    let name: String
    let url: String
}

struct PokemonDetailResponse: Codable {
    let id: Int
    let abilities: [Ability]
    let sprites: SpritesInfo
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
}

//struct LocationAreaEncounters: Codable {
//    let location_area: LocationArea
//}

//struct LocationArea: Codable {
//    let name: String
//    let url: String
//}


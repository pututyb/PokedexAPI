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
}

struct Ability: Codable {
    let ability: AbilityInfo
}

struct AbilityInfo: Codable {
    let name: String
    let url: String
}


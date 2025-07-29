//
//  Pokemon.swift
//  Pokedex-UIKit
//
//  Created by Joje on 28/07/25.
//

import Foundation

struct Pokemon: Codable, Identifiable {
    let name: String
    let url: String
    
    var id: Int? {
        return Int(url.split(separator: "/").last?.description ?? "0")
    }
}

struct PokemonListResponse: Codable {
    let results: [Pokemon]
}


//
//  PokedexViewModel.swift
//  Pokedex-UIKit
//
//  Created by Joje on 28/07/25.
//

import Foundation

class PokedexViewModel {
    
    var pokemons: [Pokemon] = []
    var onDataUpdated: (() -> Void)?

    func fetchData() {
        NetworkService.shared.fetchPokemonList { [weak self] result in
            switch result {
            case.success(let pokemons):
                self?.pokemons = pokemons
                self?.onDataUpdated?()
            case.failure(let error):
                print(error)
            }
        }
    }
}

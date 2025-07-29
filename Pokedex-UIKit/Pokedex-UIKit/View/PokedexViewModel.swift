//
//  PokedexViewModel.swift
//  Pokedex-UIKit
//
//  Created by Joje on 28/07/25.
//

import Foundation

class PokedexViewModel {
    
    private var allPokemons: [Pokemon] = []
    var filteredPokemons: [Pokemon] = []
    var pokemons: [Pokemon] = []
    
    var onDataUpdated: (() -> Void)?
    
    var onError: ((String) -> Void)?
    
    func fetchData() {
        NetworkService.shared.fetchPokemonList { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let pokemons):
                    self?.pokemons = pokemons
                    self?.onDataUpdated?() // Agora isso é seguro
                    
                case .failure(let error):
                    // Agora é seguro chamar a função que apresenta o alerta
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func filterPokemons(with query: String) {
        if query.isEmpty {
            filteredPokemons = allPokemons
        } else {
            filteredPokemons = allPokemons.filter { $0.name.lowercased().contains(query.lowercased()) }
        }
        onDataUpdated?()
    }
}

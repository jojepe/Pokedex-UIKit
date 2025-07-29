//
//  PokemonDetailViewController.swift
//  Pokedex-UIKit
//
//  Created by Joje on 29/07/25.
//

import UIKit


class PokemonDetailViewController: UIViewController {
    
    var pokemon: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        if let pokemon = pokemon {
            title = pokemon.name.capitalized
            //... configurar labels, imagens, etc., com os detalhes do Pokémon
        }
    }
}

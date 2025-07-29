//
//  NetworkService.swift
//  Pokedex-UIKit
//
//  Created by Joje on 28/07/25.
//

import Foundation

enum NetworkServiceError: Error {
    case invalidURL
    case decodingError(Error)
    case invalidResponse
    case requestFailed(Error)
}

class NetworkService {
    
    static let shared = NetworkService()
    private init() {}

    func fetchPokemonList(completion: @escaping (Result<[Pokemon], NetworkServiceError>) -> Void) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151") else {
            completion(.failure(.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }

            do {
                let pokemonResponse = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                DispatchQueue.main.async {
                    //completion(.success(pokemonResponse.results))
                }
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }

        task.resume()
    }
    
    // Futuramente, adicionaremos uma função para buscar detalhes de um Pokémon
    // func fetchPokemonDetails(for id: Int, completion: @escaping (Result<PokemonDetail, NetworkError>) -> Void) {... }
}

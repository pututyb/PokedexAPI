//
//  ViewModelViewController.swift
//  PokedexAPI
//
//  Created by Putut Yusri Bahtiar on 20/07/23.
//

import Foundation


class ViewModelViewController {
    
    var pokemon: [Pokemon] = []
    var detailData = [PokemonDetailResponse]()
    var details: [Ability] = []
    
    var reloadDataAction: (() -> Void)?
    
    func pokeGet()  {
        APIManager.sharedInstance.fetchData(from: "https://pokeapi.co/api/v2/pokemon/") { (result: Result<PokemonListResponse, Error>) in
            
            switch result {
            case .success(let pokemonListResponse):
                self.pokemon = pokemonListResponse.results
                self.pokemon.append(contentsOf: pokemonListResponse.results)
                self.fetchAllDetails()
            case .failure(let error):
                
                print("Error: \(error)")
            }
        }
    }
    
    func fetchAllDetails() {
        for pokemonIndex in 0..<pokemon.count {
            let pokeData = pokemon[pokemonIndex]
            fetchDataDetails(pokemon: pokeData)
        }
    }
    
    func fetchDataDetails(pokemon: Pokemon) {
        APIManager.sharedInstance.fetchData(from: pokemon.url) { (result: Result<PokemonDetailResponse, Error>) in
            
            switch result {
            case .success(let pokemonDetailResponse):
                self.detailData.append(pokemonDetailResponse)
                if !self.detailData.isEmpty, self.detailData.count == self.pokemon.count {
//                    self.collectionChange.reloadData()
                    guard let unwrappedReloadDataAction = self.reloadDataAction else { return }
                    unwrappedReloadDataAction()
                }
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func movetoDetailView(indexPath: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            print(strongSelf.details)
            if !strongSelf.pokemon.isEmpty {
                self?.fetchDataDetails(pokemon: strongSelf
                    .pokemon[indexPath])
            }
        }
    }
    
    func cgSize() -> CGSize {
        let width = 170
        let height = 200
        return CGSize(width: width, height: height)
    }
}

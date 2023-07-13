//
//  ViewController.swift
//  PokedexAPI
//
//  Created by Putut Yusri Bahtiar on 12/07/23.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var pokemon: [Pokemon] = []
    var details: [Ability] = []
    var detailData = [PokemonDetailResponse]()
    
    var isLoadDataDone = false
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionChange.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PokemonCollectionViewCell else { return UICollectionViewCell()}
        
        let pokemonObject = pokemon[indexPath.item]
        
        cell.lblName.text = pokemonObject.name
        cell.lblURL.text = pokemonObject.url
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let selectedPokemon = pokemon[indexPath.item]
        movetoDetailView(with: selectedPokemon, id: indexPath.item)
//        fetchDataDetails(pokemon: selectedPokemon)
    }
    
    func movetoDetailView(with pokemon: Pokemon, id: Int) {
        let storyboard = UIStoryboard(name: "PokeDetailView", bundle: nil)
        guard let moveDetailView = storyboard.instantiateViewController(withIdentifier: "PokeDetailViewController") as? PokeDetailViewController else { return }
        
        print("count: \(details.count)")
        moveDetailView.details = detailData[id].abilities
        navigationController?.pushViewController(moveDetailView, animated: true)
    }
    
    
    @IBOutlet weak var collectionChange: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionChange.dataSource = self
        collectionChange.delegate = self
        
        let uinib = UINib(nibName: "PokemonCollectionViewCell", bundle: nil)
        collectionChange.register(uinib, forCellWithReuseIdentifier: "cell")
       
        pokeGet()
        
        collectionChange.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
    }
    
    func fetchAllDetails() {
        for pokemonIndex in 0..<pokemon.count {
            let pokeData = pokemon[pokemonIndex]
            fetchDataDetails(pokemon: pokeData)
        }
    }
    
    func fetchDataDetails(pokemon: Pokemon) {
        print("Start fetching \(pokemon.url)")
        APIManager.sharedInstance.fetchData(from: pokemon.url) { (result: Result<PokemonDetailResponse, Error>) in
    
            switch result {
            case .success(let pokemonDetailResponse):
//                self.details = pokemonDetailResponse.abilitiessss
                self.detailData.append(pokemonDetailResponse)
                print("Done fetching \(pokemon.url)")
                print(self.details.count)
                if self.detailData.count == self.pokemon.count {
                    self.detailData = self.detailData.sorted { $0.id < $1.id }
                    self.collectionChange.reloadData()
                    print("Done all")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    
    func pokeGet()  {
         APIManager.sharedInstance.fetchData(from: "https://pokeapi.co/api/v2/pokemon/") { (result: Result<PokemonListResponse, Error>) in
            
            switch result {
            case .success(let pokemonListResponse):
                self.pokemon = pokemonListResponse.results
                print(self.pokemon.first)
                self.fetchAllDetails()
                self.collectionChange.reloadData()
            case .failure(let error):
                
                print("Error: \(error)")
            }
        }
    }
    
    
}


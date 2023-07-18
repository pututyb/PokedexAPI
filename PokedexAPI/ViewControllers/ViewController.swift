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
        let pokemonImage = detailData[indexPath.item]
        
        
        cell.lblName.text = pokemonObject.name
        cell.imgGambar.sd_setImage(with: URL(string: detailData[indexPath.item].sprites.front_default)!)
        print(pokemonImage.sprites.back_default)
        
        // Configure the cell
        cell.layer.cornerRadius = 15.0
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 1
        cell.layer.masksToBounds = false //<-
        
       
        
        
//        print("Jumlah data awal sekarang: \(pokemon.count), jumlah data detail sekarang: \(detailData.count)")
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        _ = pokemon[indexPath.item]
        movetoDetailView(indexPath: indexPath.item)
//        fetchDataDetails(pokemon: selectedPokemon)
        let storyboard = UIStoryboard(name: "PokeDetailView", bundle: nil)
        guard let moveDetailView = storyboard.instantiateViewController(withIdentifier: "PokeDetailViewController") as? PokeDetailViewController else { return }
        moveDetailView.details = detailData[indexPath.item]
        
        let cell = collectionChange.cellForItem(at: indexPath) as! PokemonCollectionViewCell
//        moveDetailView.penampungGambar = cell.imgGambar.image!
        self.navigationController?.pushViewController(moveDetailView, animated: true)
        
        
        
    }
    
    func movetoDetailView(indexPath: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            print(strongSelf.details)
            if !strongSelf.pokemon.isEmpty {
                strongSelf.fetchDataDetails(pokemon: strongSelf.pokemon[indexPath])
            }
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func fetchAllDetails() {
        for pokemonIndex in 0..<pokemon.count {
            let pokeData = pokemon[pokemonIndex]
            fetchDataDetails(pokemon: pokeData)
        }
    }
    
    func pokeGet()  {
         APIManager.sharedInstance.fetchData(from: "https://pokeapi.co/api/v2/pokemon/") { (result: Result<PokemonListResponse, Error>) in
            
            switch result {
            case .success(let pokemonListResponse):
                self.pokemon = pokemonListResponse.results
                self.pokemon.append(contentsOf: pokemonListResponse.results)
//                self.collectionChange.reloadData()
                print("Udah selesai, count: \(self.pokemon.count)")
                self.fetchAllDetails()
            case .failure(let error):
                
                print("Error: \(error)")
            }
        }
    }
    
    func fetchDataDetails(pokemon: Pokemon) {
        APIManager.sharedInstance.fetchData(from: pokemon.url) { (result: Result<PokemonDetailResponse, Error>) in
    
            switch result {
            case .success(let pokemonDetailResponse):
                self.detailData.append(pokemonDetailResponse)
                if !self.detailData.isEmpty, self.detailData.count == self.pokemon.count {
                    self.collectionChange.reloadData()
                }
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
//    func fetchLocationAreaEncounter(pokemon: Pokemon) {
//        APIManager.sharedInstance.fetchData(from: pokemon.url) { (result: Result<PokemonDetailResponse, Error>) in
//
//            switch result {
//            case .success(let pokemonDetailResponse):
//                self.detailData.append(pokemonDetailResponse)
//                print("Finished fetching \(pokemon.name), jumlah sekarang: \(self.detailData.count)")
//                if !self.detailData.isEmpty, self.detailData.count == self.pokemon.count {
//                    self.collectionChange.reloadData()
//                }
//
//            case .failure(let error):
//                print("Error: \(error)")
//            }
//        }
//    }
    
    
    
}


//
//  ViewController.swift
//  PokedexAPI
//
//  Created by Putut Yusri Bahtiar on 12/07/23.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let viewModel = ViewModelViewController()
    
    var isLoadDataDone = false
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pokemon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionChange.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PokemonCollectionViewCell else { return UICollectionViewCell()}
        
        let pokemonObject = viewModel.pokemon[indexPath.item]
        let pokemonImage = viewModel.detailData[indexPath.item]
        
        
        cell.lblName.text = pokemonObject.name
        cell.imgGambar.sd_setImage(with: URL(string: viewModel.detailData[indexPath.item].sprites.front_default)!)
        
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
        return viewModel.cgSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        _ = viewModel.pokemon[indexPath.item]
        viewModel.movetoDetailView(indexPath: indexPath.item)
        let storyboard = UIStoryboard(name: "PokeDetailView", bundle: nil)
        guard let moveDetailView = storyboard.instantiateViewController(withIdentifier: "PokeDetailViewController") as? PokeDetailViewController else { return }
        moveDetailView.details = viewModel.detailData[indexPath.item]
        
        _ = collectionChange.cellForItem(at: indexPath) as! PokemonCollectionViewCell
        self.navigationController?.pushViewController(moveDetailView, animated: true)
        
        
        
    }
    
    
    
    
    @IBOutlet weak var collectionChange: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionChange.dataSource = self
        collectionChange.delegate = self
        
        let uinib = UINib(nibName: "PokemonCollectionViewCell", bundle: nil)
        collectionChange.register(uinib, forCellWithReuseIdentifier: "cell")
       
        viewModel.reloadDataAction = { [weak self] in
            self?.collectionChange.reloadData()
            print("Reload")
        }
        
        viewModel.pokeGet()
        
        collectionChange.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
}


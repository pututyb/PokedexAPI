//
//  PokeDetailViewController.swift
//  PokedexAPI
//
//  Created by Putut Yusri Bahtiar on 13/07/23.
//

import UIKit
import SDWebImage
import CoreData

class PokeDetailViewController: UIViewController, PokeDetailViewModelDelegate {
    
    
    var viewModel = PokeDetailViewModel()
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var prgsDefense: UIProgressView!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblImage: UIImageView!
    @IBOutlet weak var prgsSpeed: UIProgressView!
    @IBOutlet weak var prgsSpecialAttack: UIProgressView!
    @IBOutlet weak var prgsAttack: UIProgressView!
    @IBOutlet weak var prgsSpecialDefense: UIProgressView!
    @IBOutlet weak var lblSpecies: UILabel!
    @IBOutlet weak var lblAbilityName: UILabel!
    @IBOutlet weak var prgsHP: UIProgressView!
    @IBOutlet weak var btnLikeSave: UIButton!
    @IBAction func btnLikeSavePressed(_ sender: Any) {
        guard let saveName = viewModel.details?.name else { return }
        if viewModel.isExists {
            viewModel.deleteData(saveName)
            self.btnLikeSave.setImage(UIImage(systemName: "heart"), for: .normal)
            viewModel.isExists = false
        } else {
            if let details = viewModel.details {
                viewModel.saveData(with: details)
                self.btnLikeSave.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                viewModel.isExists = true
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.showAllDataDetails()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        let words = viewModel.abilities.split { $0.isWhitespace }
        let formattedAbilities = words.map { $0.capitalized }.joined(separator: " ")
        print("[\"\(formattedAbilities)\"]")
        
        let species = viewModel.species.split { $0.isWhitespace }
        let formattedSpecies = species.map { $0.capitalized }.joined(separator: " ")
        print("[\"\(formattedSpecies)\"]")
        
        let stats = viewModel.stats.split { $0.isWhitespace }
        let formattedStats = stats.map { $0.capitalized }.joined(separator: " ")
        print("[\"\(formattedStats)\"]")
        
        lblAbilityName.text = formattedAbilities
        lblHeight.text = String(viewModel.details?.height ?? 0)
        lblName.text = viewModel.details?.name
        lblSpecies.text = formattedSpecies
        lblWeight.text = String(viewModel.details?.weight ?? 0)
        setWarnaStats(bar: prgsHP, nilai: viewModel.details?.stats[0].base_stat ?? 0)
        prgsHP.progress = Float(viewModel.details?.stats[0].base_stat ?? 0)/100
        
        setWarnaStats(bar: prgsAttack, nilai: viewModel.details?.stats[1].base_stat ?? 0)
        prgsAttack.progress = Float(viewModel.details?.stats[1].base_stat ?? 0)/100
        
        setWarnaStats(bar: prgsDefense, nilai: viewModel.details?.stats[2].base_stat ?? 0)
        prgsDefense.progress = Float(viewModel.details?.stats[2].base_stat ?? 0)/100
        
        setWarnaStats(bar: prgsSpecialAttack, nilai: viewModel.details?.stats[3].base_stat ?? 0)
        prgsSpecialAttack.progress = Float(viewModel.details?.stats[3].base_stat ?? 0)/100
        
        setWarnaStats(bar: prgsSpecialDefense, nilai: viewModel.details?.stats[4].base_stat ?? 0)
        prgsSpecialDefense.progress = Float(viewModel.details?.stats[4].base_stat ?? 0)/100
        
        setWarnaStats(bar: prgsSpeed, nilai: viewModel.details?.stats[5].base_stat ?? 0)
        prgsSpeed.progress = Float(viewModel.details?.stats[5].base_stat ?? 0)/100
        
        
        
        if let spriteURLString = viewModel.details?.sprites.front_default,
            let spriteURL = URL(string: spriteURLString) {
            lblImage.sd_setImage(with: spriteURL) { [weak self] (image, error, _, _) in
                if let image = image {
                    self?.viewModel.pokeImage = image
                } else {
                    print("Failed to load image: \(error?.localizedDescription ?? "")")
                }
            }
        }
        func setWarnaStats(bar: UIProgressView, nilai: Int) {
            if nilai <= 30 {
                return bar.tintColor = .yellow
            } else if nilai <= 50 {
                return bar.tintColor = .green
            } else if nilai >= 50 {
                return bar.tintColor = .red
            }
        }
        
        
        //        self.btnLikeSave.isEnabled = false
        viewModel.checkData(lblName.text!) { [weak self] isExists in
            self?.viewModel.isExists = isExists
            let iconChange = isExists ? "heart.fill" : "heart"
            self?.btnLikeSave.setImage(UIImage(systemName: iconChange), for: .normal)
            self?.btnLikeSave.isEnabled = true
        }
    }
    
    func pokeImageDidChange(with image: UIImage?) {
        if let image = image {
            lblImage.image = image
        }
    }
    
    func pokeDetailDidChange() {
        //
    }
    
    func pokeDetailFetchFailed(with error: Error) {
        //
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
}

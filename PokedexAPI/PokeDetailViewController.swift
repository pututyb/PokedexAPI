//
//  PokeDetailViewController.swift
//  PokedexAPI
//
//  Created by Putut Yusri Bahtiar on 13/07/23.
//

import UIKit
import SDWebImage

class PokeDetailViewController: UIViewController {
    var details: PokemonDetailResponse?
    var abilities = ""
    var penampungGambar = UIImage()
    
    @IBOutlet weak var lblImage: UIImageView!
    @IBOutlet weak var lblAbilityName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0..<(details?.abilities.count ?? 0) {
            let ability = details?.abilities[i].ability.name ?? "Unknown"
            print("ability \(i)", ability)
            
            abilities += "\(ability), " // Concatenate abilities
        }
        
        if abilities.hasSuffix(", ") {
            abilities = String(abilities.dropLast(2))
        }
        
        lblAbilityName.text = abilities
        
        print("gambar ini \(details?.sprites.front_default ?? "Unknown")")
        if let spriteURLString = details?.sprites.front_default, let spriteURL = URL(string: spriteURLString) {
            lblImage.sd_setImage(with: spriteURL, completed: nil)
        }
    }
}

//
//  PokemonLikesTableViewCell.swift
//  PokedexAPI
//
//  Created by Putut Yusri Bahtiar on 17/07/23.
//

import UIKit

class PokemonLikesTableViewCell: UITableViewCell {
    
//    var favpokemon: PokemonImage?

    @IBOutlet weak var imagePoke: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        print(favpokemon)
    }
    
    func configure(with pokemon: Pokemon) {
        lblName.text = pokemon.name
//        imagePoke.image = favpokemon?.imagePoke
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//        print(favpokemon)
    }
    
}

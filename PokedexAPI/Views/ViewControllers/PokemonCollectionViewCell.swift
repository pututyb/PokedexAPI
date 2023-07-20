//
//  PokemonCollectionViewCell.swift
//  PokedexAPI
//
//  Created by Putut Yusri Bahtiar on 12/07/23.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {
    
    var cornerRadius: CGFloat = 5.0

    @IBOutlet weak var imgGambar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}

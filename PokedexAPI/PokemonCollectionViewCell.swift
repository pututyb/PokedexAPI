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
    @IBOutlet weak var lblURL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layer.cornerRadius = cornerRadius
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.50
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 20)
    }

}

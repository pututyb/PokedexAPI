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
    var species = ""
    var stats = ""
    var penampungGambar = UIImage()
    var duration = 10.0
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        showAllDataDetails()
        
        let words = abilities.split { $0.isWhitespace }
        let formattedAbilities = words.map { $0.capitalized }.joined(separator: " ")
        print("[\"\(formattedAbilities)\"]")
        
        let species = species.split { $0.isWhitespace }
        let formattedSpecies = species.map { $0.capitalized }.joined(separator: " ")
        print("[\"\(formattedSpecies)\"]")
        
        let stats = stats.split { $0.isWhitespace }
        let formattedStats = stats.map { $0.capitalized }.joined(separator: " ")
        print("[\"\(formattedStats)\"]")
        
        lblAbilityName.text = formattedAbilities
        lblHeight.text = String(details?.height ?? 0)
        lblName.text = details?.name
        lblSpecies.text = formattedSpecies
        lblWeight.text = String(details?.weight ?? 0)
        setWarnaStats(bar: prgsHP, nilai: details?.stats[0].base_stat ?? 0)
        prgsHP.progress = Float(details?.stats[0].base_stat ?? 0)/100
        
        setWarnaStats(bar: prgsAttack, nilai: details?.stats[1].base_stat ?? 0)
        prgsHP.progress = Float(details?.stats[1].base_stat ?? 0)/100
        
        setWarnaStats(bar: prgsDefense, nilai: details?.stats[2].base_stat ?? 0)
        prgsDefense.progress = Float(details?.stats[2].base_stat ?? 0)/100
        
        setWarnaStats(bar: prgsSpecialAttack, nilai: details?.stats[3].base_stat ?? 0)
        prgsSpecialAttack.progress = Float(details?.stats[3].base_stat ?? 0)/100
        
        setWarnaStats(bar: prgsSpecialDefense, nilai: details?.stats[4].base_stat ?? 0)
        prgsSpecialDefense.progress = Float(details?.stats[4].base_stat ?? 0)/100
        
        setWarnaStats(bar: prgsSpeed, nilai: details?.stats[5].base_stat ?? 0)
        prgsSpeed.progress = Float(details?.stats[5].base_stat ?? 0)/100
        
//        prgsAttacka.progress = Float(details?.stats[0].base_stat ?? 0)
//        UIView.animate(withDuration: duration,
//                           delay: 0.0, options: [.curveLinear, .beginFromCurrentState, .preferredFramesPerSecond60],
//                       animations: { self.prgsAttacka.layoutIfNeeded() },
//                           completion: nil)
        
        
        print("gambar ini \(details?.sprites.front_default ?? "Unknown")")
        if let spriteURLString = details?.sprites.front_default, let spriteURL = URL(string: spriteURLString) {
            lblImage.sd_setImage(with: spriteURL, completed: nil)
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
    }
}

extension PokeDetailViewController {
    func showAllDataDetails() {
        for skill in 0..<(details?.abilities.count ?? 0) {
            let ability = details?.abilities[skill].ability.name ?? "Unknown"
            print("Skill \(skill)", ability)
            
            abilities += "\(ability) " // Concatenate abilities
        }
        
        
        for name in 0..<(details?.types.count ?? 0) {
            let ability = details?.types[name].type.name ?? "Unknown"
            print("Species \(name)", ability)
            
            species += "\(ability) " // Concatenate abilities
        }
        
        for stat in 0..<(details?.stats.count ?? 0) {
            let ability = details?.stats[stat].base_stat ?? 0
            print("Base Stats \(stat)", ability)
            
            stats += "\(ability) " // Concatenate abilities
            
//            print(s)
        }
    }
}

//
//  PokeDetailViewController.swift
//  PokedexAPI
//
//  Created by Putut Yusri Bahtiar on 13/07/23.
//

import UIKit

class PokeDetailViewController: UIViewController {
    var details: [Ability] = []
    
    @IBOutlet weak var lblAbilityName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        lblAbilityName.text = details[0].ability.name + " " + details[1].ability.name
//        if let firstAbility = details.first {
//            lblAbilityName.text = firstAbility.ability.name
//        }
        
    }
}

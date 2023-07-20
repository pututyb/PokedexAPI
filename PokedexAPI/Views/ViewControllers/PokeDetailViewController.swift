//
//  PokeDetailViewController.swift
//  PokedexAPI
//
//  Created by Putut Yusri Bahtiar on 13/07/23.
//

import UIKit
import SDWebImage
import CoreData

class PokeDetailViewController: UIViewController {
    var details: PokemonDetailResponse?
    var abilities = ""
    var species = ""
    var stats = ""
    var moves = ""
    var duration = 10.0
    var pokeimage: PokemonImage?
    var isExists: Bool = false
    
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
        guard let saveName = details?.name else { return }
        if isExists {
            deleteData(saveName)
            self.btnLikeSave.setImage(UIImage(systemName: "heart"), for: .normal)
            isExists = false
        } else {
            if let details = details {
                saveData(with: details)
                self.btnLikeSave.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                isExists = true
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        showAllDataDetails()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
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
        prgsAttack.progress = Float(details?.stats[1].base_stat ?? 0)/100
        
        setWarnaStats(bar: prgsDefense, nilai: details?.stats[2].base_stat ?? 0)
        prgsDefense.progress = Float(details?.stats[2].base_stat ?? 0)/100
        
        setWarnaStats(bar: prgsSpecialAttack, nilai: details?.stats[3].base_stat ?? 0)
        prgsSpecialAttack.progress = Float(details?.stats[3].base_stat ?? 0)/100
        
        setWarnaStats(bar: prgsSpecialDefense, nilai: details?.stats[4].base_stat ?? 0)
        prgsSpecialDefense.progress = Float(details?.stats[4].base_stat ?? 0)/100
        
        setWarnaStats(bar: prgsSpeed, nilai: details?.stats[5].base_stat ?? 0)
        prgsSpeed.progress = Float(details?.stats[5].base_stat ?? 0)/100
        
        
        
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
        
//        self.btnLikeSave.isEnabled = false
        checkData(lblName.text!) { [weak self] isExists in
            self?.isExists = isExists
            let iconChange = isExists ? "heart.fill" : "heart"
            self?.btnLikeSave.setImage(UIImage(systemName: iconChange), for: .normal)
            self?.btnLikeSave.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func saveData(with details: PokemonDetailResponse) {
        print("Like Pokemon")

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext

        let userEntity = NSEntityDescription.entity(forEntityName: "PokemonCore", in: managedContext)

        let insert = NSManagedObject(entity: userEntity!, insertInto: managedContext)
        insert.setValue(details.name, forKey: "name")

        if let image = lblImage.image {
            let base64String = convertImageToBase64String(img: image)
            insert.setValue(base64String, forKey: "imagePoke")
        } else {
            print("Failed to load image")
        }

        do {
            try managedContext.save()
            print("Data saved into Core Data")
        } catch let error {
            print("Failed to save data: \(error)")
        }
    }

    
    func convertImageToBase64String(img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }

    func convertBase64StringToImage(imageBase64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: imageBase64String) else {
            return nil
        }
        return UIImage(data: imageData)
    }
    
    func deleteData( _ name: String) {
        guard let appDelegeate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegeate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "PokemonCore")
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            for index in 0..<result.count {
                let dataToDelete = result[index] as! NSManagedObject
                managedContext.delete(dataToDelete)
                print("Delete Data: ",dataToDelete)
                try managedContext.save()
            }
        } catch let err {
            print("Unable to update data: ",err)
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
        }
        
        for move in 0..<(details?.moves.count ?? 0) {
            let ability = details?.moves[move].move.name ?? "Unknown"
            print("Moves \(move)", ability)
            
            moves += "\(ability) " // Concatenate abilities
        }
    }
    
    func checkData(_ name: String, completion: @escaping (Bool) -> Void) {
        guard let appDelegeate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegeate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "PokemonCore")
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            let isExists = result.count > 0
            completion(isExists)
        } catch {
            
        }
    }
}

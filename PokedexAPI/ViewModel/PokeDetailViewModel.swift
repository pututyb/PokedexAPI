//
//  PokeDetailViewModel.swift
//  PokedexAPI
//
//  Created by Putut Yusri Bahtiar on 20/07/23.
//

import Foundation
import UIKit
import CoreData


protocol PokeDetailViewModelDelegate: AnyObject {
    func pokeDetailDidChange()
    func pokeDetailFetchFailed(with error: Error)
}

class PokeDetailViewModel {
    
    var details: PokemonDetailResponse?
    var abilities = ""
    var species = ""
    var stats = ""
    var moves = ""
    var duration = 10.0
    var lblImage: UIImage?
    var pokeimage: PokemonImage?
    var isExists: Bool = false
    
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
    
    func saveData(with details: PokemonDetailResponse) {
        print("Like Pokemon")

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext

        let userEntity = NSEntityDescription.entity(forEntityName: "PokemonCore", in: managedContext)

        let insert = NSManagedObject(entity: userEntity!, insertInto: managedContext)
        insert.setValue(details.name, forKey: "name")

        if let image = lblImage {
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
    
    func convertImageToBase64String(img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }

    func convertBase64StringToImage(imageBase64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: imageBase64String) else {
            return nil
        }
        return UIImage(data: imageData)
    }
    
    
}

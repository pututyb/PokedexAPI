//
//  PokemonLikesViewModel.swift
//  PokedexAPI
//
//  Created by Putut Yusri Bahtiar on 18/07/23.
//

import Foundation
import CoreData
import UIKit

protocol PokemonLikesViewModelDelegate: AnyObject {
    func pokemonLikesDidChange()
    func pokemonLikesFetchFailed(with error: Error)
}

class PokemonLikesViewModel {
    private var dataPokemon: [PokemonCore] = []
    weak var delegate: PokemonLikesViewModelDelegate?
    
    func fetchPokemonLikes() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PokemonCore")
        
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest) as? [PokemonCore] ?? []
            dataPokemon = fetchedResults
            delegate?.pokemonLikesDidChange()
        } catch let error as NSError {
            delegate?.pokemonLikesFetchFailed(with: error)
        }
    }
    
    func numberOfPokemon() -> Int {
        return dataPokemon.count
    }
    
    func pokemon(at index: Int) -> PokemonCore {
        return dataPokemon[index]
    }
    
    func deletePokemon(at index: Int) {
        let pokemon = dataPokemon[index]
        if let name = pokemon.name {
            deleteData(name)
            dataPokemon.remove(at: index)
            delegate?.pokemonLikesDidChange()
        }
    }
    
    private func deleteData(_ name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "PokemonCore")
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            for dataToDelete in result {
                if let objectToDelete = dataToDelete as? NSManagedObject {
                    managedContext.delete(objectToDelete)
                }
            }
            try managedContext.save()
        } catch let error {
            print("Unable to delete data: ", error)
        }
    }
    
    
    func handleMoveToUpdate(at indexPath: IndexPath, completion: @escaping (String) -> Void) -> UIAlertController {
            let alertController = UIAlertController(title: "Edit Poke Name", message: nil, preferredStyle: .alert)
            alertController.addTextField { textField in
                textField.placeholder = "New Name"
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let updateAction = UIAlertAction(title: "Update", style: .default) { _ in
                guard let newName = alertController.textFields?.first?.text else {
                    return
                }
                
                self.performDataUpdate(at: indexPath, with: newName, completion: completion)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(updateAction)
            
            return alertController
        }
        
        private func performDataUpdate(at indexPath: IndexPath, with newName: String, completion: @escaping (String) -> Void) {
            let pokemon = self.pokemon(at: indexPath.row)
            pokemon.name = newName

            // Update the data in Core Data

            // Call the completion handler with the new name
            completion(newName)
        }

}

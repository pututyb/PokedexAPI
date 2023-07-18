//
//  PokemonLikesTableViewController.swift
//  PokedexAPI
//
//  Created by Putut Yusri Bahtiar on 17/07/23.
//

import UIKit
import CoreData

class PokemonLikesTableViewController: UIViewController {
    
    @IBOutlet weak var tablePokemonLikes: UITableView!
    
    private var dataPokemon = [PokemonCore]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablePokemonLikes.dataSource = self
        tablePokemonLikes.delegate = self
        tablePokemonLikes.register(UINib(nibName: "PokemonLikesTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
//        fetchData()
        
    }
    
    func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PokemonCore")
        
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
//
//            dataPokemon.removeAll()
//            dataPokemon.append(contentsOf: fetchedResults as! [PokemonCore])
            dataPokemon = fetchedResults as! [PokemonCore]
            
            DispatchQueue.main.async { [weak self] in
                print(fetchedResults.count)
                self?.tablePokemonLikes.reloadData()
            }
        } catch let error as NSError {
            print("Fetch error: \(error), \(error.userInfo)")
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

    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchData()
    }

}

extension PokemonLikesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tablePokemonLikes.dequeueReusableCell(withIdentifier: "cell") as? PokemonLikesTableViewCell else {
            return UITableViewCell()
        }
        
        cell.lblName.text = dataPokemon[indexPath.row].name ?? "kosong"
        
        if let stringImage = dataPokemon[indexPath.row].imagePoke {
            if let convertedImage = stringImage.imageFromBase64 {
                cell.imagePoke.image = convertedImage
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataPokemon.count
    }
    
    private func handleMoveToTrash(at indexPath: IndexPath) {
        let pokemon = dataPokemon[indexPath.row]
        if let name = pokemon.name {
            deleteData(name)
            dataPokemon.remove(at: indexPath.row)
            tablePokemonLikes.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    private func handleMoveToUpdate(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Edit Pokemon Name", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "New Name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let updateAction = UIAlertAction(title: "Update", style: .default) { [weak self] _ in
            guard let newName = alertController.textFields?.first?.text else {
                return
            }
            
            self?.performDataUpdate(at: indexPath, with: newName)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(updateAction)
        
        present(alertController, animated: true)
    }

    func performDataUpdate(at indexPath: IndexPath, with newName: String) {
        let pokemon = dataPokemon[indexPath.row]
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        pokemon.name = newName
        
        do {
            try managedContext.save()
            print("Data updated successfully")
            tablePokemonLikes.reloadRows(at: [indexPath], with: .automatic)
        } catch let error as NSError {
            print("Failed to update data: \(error), \(error.userInfo)")
        }
    }

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Trash action
        let trash = UIContextualAction(style: .destructive,
                                       title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.handleMoveToTrash(at: indexPath)
            completionHandler(true)
        }
        trash.backgroundColor = .systemBlue
        
        let edit = UIContextualAction(style: .normal,
                                       title: "Edit") { [weak self] (action, view, completionHandler) in
            self?.handleMoveToUpdate(at: indexPath)
            completionHandler(true)
        }
        edit.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [trash, edit])
        
        return configuration
    }
}

//
//  PokemonLikesTableViewController.swift
//  PokedexAPI
//
//  Created by Putut Yusri Bahtiar on 18/07/23.
//

import UIKit

class PokemonLikesTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    private let viewModel = PokemonLikesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PokemonLikesTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")

        viewModel.delegate = self
        viewModel.fetchPokemonLikes()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        viewModel.fetchPokemonLikes()
    }

    private func handleMoveToTrash(at indexPath: IndexPath) {
        viewModel.deletePokemon(at: indexPath.row)
    }

    
}

extension PokemonLikesTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPokemon()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? PokemonLikesTableViewCell else {
            return UITableViewCell()
        }

        let pokemon = viewModel.pokemon(at: indexPath.row)
        cell.lblName.text = pokemon.name

        if let stringImage = pokemon.imagePoke {
            if let convertedImage = stringImage.imageFromBase64 {
                cell.imagePoke.image = convertedImage
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trashAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            self?.handleMoveToTrash(at: indexPath)
            completionHandler(true)
        }

        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completionHandler) in
            self?.handleMoveToUpdate(at: indexPath)
            completionHandler(true)
        }

        return UISwipeActionsConfiguration(actions: [trashAction, editAction])
    }
    
    private func handleMoveToUpdate(at indexPath: IndexPath) {
        let alertController = viewModel.handleMoveToUpdate(at: indexPath) { [weak self] newName in
            
            if let cell = self?.tableView.cellForRow(at: indexPath) as? PokemonLikesTableViewCell {
                cell.lblName.text = newName
            }
        }

        present(alertController, animated: true)
    }
    
    /// Untuk Update data CoreData
    /// - Parameters:
    ///   - indexPath: barisnya
    ///   - newName: isi nama penggantinya apa
    private func performDataUpdate(at indexPath: IndexPath, with newName: String) {
        let pokemon = viewModel.pokemon(at: indexPath.row)
        pokemon.name = newName
    }
}

extension PokemonLikesTableViewController: PokemonLikesViewModelDelegate {
    func pokemonLikesDidChange() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    func pokemonLikesFetchFailed(with error: Error) {
        print("Error: \(error)")
    }
}

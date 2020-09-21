//
//  CitiesSelectioonViewController.swift
//  WeatherWatcher
//
//  Created by Shamas on 20/9/20.
//

import UIKit

class CitiesSelectionViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: CitiesSelectionViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModelCallBacks()
        setupTableView()
        setupSearchBar()
    }
    
    func setupViewModelCallBacks() {
        viewModel.dataUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupTableView() {
        tableView.allowsMultipleSelection = true
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension CitiesSelectionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.userUpdatedString(searchString: searchText)
    }
}

extension CitiesSelectionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.citiesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CitySelectionTableViewCell.cellIdentifier, for: indexPath)
        
        if let cityCell = cell as? CitySelectionTableViewCell {
            cityCell.viewModel = viewModel.cityViewModelForIndex(index: indexPath.row)
            if cityCell.viewModel.isSelected {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectionChangedFor(isSelected: true, index: indexPath.row)
        reloadViewForIndexPath(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        viewModel.selectionChangedFor(isSelected: false, index: indexPath.row)
        reloadViewForIndexPath(indexPath: indexPath)
    }
    
    func reloadViewForIndexPath(indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

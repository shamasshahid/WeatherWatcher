//
//  WeatherDetailViewController.swift
//  WeatherWatcher
//
//  Created by Shamas on 21/9/20.
//

import UIKit

class WeatherDetailViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var viewModel: WeatherDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    func setupTableView() {
        tableview.delegate = self
        tableview.dataSource = self
    }
}

extension WeatherDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: WeatherDetailTableViewCell.cellIdentifier, for: indexPath)
        
        if let weatherCell = cell as? WeatherDetailTableViewCell {
            weatherCell.viewModel = viewModel.getViewModelForIndex(index: indexPath.row)
        }
        
        return cell
    }
    
}

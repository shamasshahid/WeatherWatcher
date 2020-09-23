//
//  WeatherListTableViewController.swift
//  WeatherWatcher
//
//  Created by Shamas on 21/9/20.
//

import UIKit

class WeatherListTableViewController: UITableViewController {

    static let detailSegueIdentifier = "weatherDetailSegueIdenifier"
    
    @IBOutlet var laodingView: UIView!
    @IBOutlet weak var activityIndicationLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: WeatherListViewModel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        viewModel = WeatherListViewModel(service: DependencyProvider.getService(),
                                         storage: DependencyProvider.getStorage())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createAndAddLoadingView()
        setupViewModel()
        setupLoadingViews(isLoading: viewModel.shouldShowProgressIndicator)
    }
    
    func createAndAddLoadingView() {
        navigationController?.view.addSubview(laodingView)
        // todo: set programmatic constraints
        laodingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    func setupViewModel() {
        viewModel.onWeatherDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onLoadingStatusChagned = { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.setupLoadingViews(isLoading: isLoading)
            }
        }
    }
    
    func setupLoadingViews(isLoading: Bool) {
        laodingView.isHidden = !isLoading
        activityIndicator.isHidden = !isLoading
        if isLoading {
            activityIndicationLabel.text = viewModel.activityLabelMessage
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? CitiesSelectionViewController {
            destinationVC.viewModel = viewModel.getCitySelectionViewModel()
            destinationVC.presentationController?.delegate = self
        } else if let desitnationVC = segue.destination as? WeatherDetailViewController, let viewModel = sender as? WeatherDetailViewModel {
            desitnationVC.viewModel = viewModel
        }
    }

}

extension WeatherListTableViewController: UIPopoverPresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        viewModel.fetchResults()
    }
}

extension WeatherListTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailModel = viewModel.getDetailViewModel(index: indexPath.row)
        performSegue(withIdentifier: WeatherListTableViewController.detailSegueIdentifier, sender: detailModel)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.weatherCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityWeatherTableViewCell.cellIdentifier, for: indexPath)

        if let cityWeatherCell = cell as? CityWeatherTableViewCell, let cellViewModel = viewModel.getCellViewModelForIndex(index: indexPath.row) {
            cityWeatherCell.viewModel = cellViewModel
        }

        return cell
    }
 }

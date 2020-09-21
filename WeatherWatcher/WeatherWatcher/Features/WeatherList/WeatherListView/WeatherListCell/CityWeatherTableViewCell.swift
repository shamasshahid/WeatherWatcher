//
//  CityWeatherTableViewCell.swift
//  WeatherWatcher
//
//  Created by Shamas on 20/9/20.
//

import UIKit

class CityWeatherTableViewCell: UITableViewCell {

    static let cellIdentifier = "CityWeatherTableViewCell"
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var viewModel: CityWeatherTVCViewModel! {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView() {
        cityLabel.text = viewModel.cityName
        temperatureLabel.text = viewModel.temperature
    }

}

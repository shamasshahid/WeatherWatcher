//
//  CitySelectionTableViewCell.swift
//  WeatherWatcher
//
//  Created by Shamas on 20/9/20.
//

import UIKit

class CitySelectionTableViewCell: UITableViewCell {

    static let cellIdentifier = "CitySelectionTableViewCell"
    
    @IBOutlet weak var cityLabel: UILabel!
    
    var viewModel: CitySelectionCellViewModel! {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateView() {
        cityLabel.text = viewModel.cityName
        accessoryType = viewModel.isSelected ? .checkmark : .none
    }
    
}

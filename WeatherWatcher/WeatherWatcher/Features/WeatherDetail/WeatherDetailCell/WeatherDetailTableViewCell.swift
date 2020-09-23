//
//  WeatherDetailTableViewCell.swift
//  WeatherWatcher
//
//  Created by Shamas on 23/9/20.
//

import UIKit

class WeatherDetailTableViewCell: UITableViewCell {

    static let cellIdentifier = "WeatherDetailTableViewCellIdentifier"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    var viewModel: WeatherDetailCellViewModel! {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        titleLabel.text = viewModel.titleValue
        valueLabel.text = viewModel.detailValue
    }

}

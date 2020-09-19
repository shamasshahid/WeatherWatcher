//
//  ViewController.swift
//  WeatherWatcher
//
//  Created by Shamas on 18/9/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let rout = DependencyProvider().getRoutable()
        let service = DependencyProvider().getService()
        service.fetch(urlRequest: rout) { (result) in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let failure):
                print(failure)
            }
        }
    }


}


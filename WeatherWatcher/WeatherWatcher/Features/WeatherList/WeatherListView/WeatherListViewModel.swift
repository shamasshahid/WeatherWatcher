//
//  WeatherListViewModel.swift
//  WeatherWatcher
//
//  Created by Shamas on 20/9/20.
//

import Foundation

enum PreLoadStatus {
    case notStarted
    case inProgress
    case finished
}

class WeatherListViewModel {
    
    private var router: Routable
    private let service: WebService
    private let storage: DataStorage
    
    var preLoadStatus: PreLoadStatus = .notStarted {
        didSet {
            print("new state is \(preLoadStatus)")
            if preLoadStatus == .inProgress {
                activityLabelMessage = "Setting up app data"
                shouldShowProgressIndicator = true
            } else if preLoadStatus == .finished {
                shouldShowProgressIndicator = false
                fetchResults()
            }
        }
    }
    
    var shouldShowProgressIndicator: Bool = false {
        didSet {
            onLoadingStatusChagned?(shouldShowProgressIndicator)
        }
    }
    var activityLabelMessage: String = ""
    var onWeatherDataFetched: (() -> Void)?
    var onLoadingStatusChagned: ((Bool) -> Void)?
    
    private var weatherList: [WeatherModel] = [] {
        didSet {
            onWeatherDataFetched?()
        }
    }
    
    var weatherCount: Int {
        return weatherList.count
    }
    
    init(router: Routable, service: WebService, storage: DataStorage) {
        self.router = router
        self.service = service
        self.storage = storage
        
        setupStorage()
        storage.prepareForUse()
    }
    
    private func setupStorage() {
        storage.onPreloadStarted = { [weak self] in
            self?.preLoadStatus = .inProgress
        }
        
        storage.onPreloadFinished = { [weak self] in
            self?.preLoadStatus = .finished
        }
    }
    
    func fetchResults() {
        
        router.cityIDs = storage.getIDsForSelectedCities()
        service.fetch(urlRequest: router) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.weatherList = response.list
                print(response)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func weatherModelForIndex(index: Int) -> WeatherModel? {
        guard index >= 0 && index < weatherList.count else {
            return nil
        }
        return weatherList[index]
    }
    
    func getViewModelForIndex(index: Int) -> CityWeatherTVCViewModel? {
        guard let model = weatherModelForIndex(index: index) else {
            return nil
        }
        
        return CityWeatherTVCViewModel(model: model)
    }
    
}

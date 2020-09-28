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
    
    private let service: WebService
    private var storage: Storage
    
    var activityLabelMessage: String = ""
    var onWeatherDataFetched: (() -> Void)?
    var onLoadingStatusChagned: ((Bool) -> Void)?
    
    var preLoadStatus: PreLoadStatus = .notStarted {
        didSet {
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
    
    private var weatherList: [WeatherModel] = [] {
        didSet {
            onWeatherDataFetched?()
        }
    }
    
    var weatherListCount: Int {
        return weatherList.count
    }
    
    init(service: WebService, storage: Storage) {
        self.service = service
        self.storage = storage
        
        setupStorage()
        self.storage.start()
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
        
        let router = WeatherListRouter.fetchCitiesWeather(storage.getIDsForSelectedCities())
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
    
    func getCellViewModelForIndex(index: Int) -> CityWeatherTVCViewModel? {
        guard let model = weatherModelForIndex(index: index) else {
            return nil
        }
        
        return CityWeatherTVCViewModel(model: model)
    }
    
    func getDetailViewModel(index: Int) -> WeatherDetailViewModel? {
        guard let model = weatherModelForIndex(index: index) else {
            return nil
        }
        
        return WeatherDetailViewModel(weatherModel: model)
    }
    
    func getCitySelectionViewModel() -> CitiesSelectionViewModel {
        return CitiesSelectionViewModel(storage: storage)
    }
    
}

//
//  MockService.swift
//  WeatherWatcherTests
//
//  Created by Shamas on 23/9/20.
//

import Foundation

@testable import WeatherWatcher

class MockWeatherService: WebService {
    
    var mockContentData: Data {
        return getData(name: "mockResponse")
    }
    
    func getData(name: String, withExtension: String = "json") -> Data {
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: name, withExtension: withExtension)
        let data = try! Data(contentsOf: fileUrl!)
        return data
    }
    
    func fetch(urlRequest: Routable, completionHandler: @escaping (Result<WeatherResponse, ServiceError>) -> Void) {
        let data = mockContentData
        if let response = try? JSONDecoder().decode(WeatherResponse.self, from: data) {
            completionHandler(.success(response))
        }
    }
}

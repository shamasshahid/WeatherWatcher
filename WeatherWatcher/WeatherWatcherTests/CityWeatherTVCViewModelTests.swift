//
//  CityWeatherTVCViewModelTests.swift
//  WeatherWatcherTests
//
//  Created by Shamas on 23/9/20.
//

import XCTest
@testable import WeatherWatcher

class CityWeatherTVCViewModelTests: XCTestCase {

    
    var mockContentData: Data {
        return getData(name: "mockWeatherObj")
    }
    
    func getData(name: String, withExtension: String = "json") -> Data {
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: name, withExtension: withExtension)
        let data = try! Data(contentsOf: fileUrl!)
        return data
    }
    
    var viewModel: CityWeatherTVCViewModel!
    
    override func setUpWithError() throws {
        let model = try! JSONDecoder().decode(WeatherModel.self, from: mockContentData)
        viewModel = CityWeatherTVCViewModel(model: model)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWeatherView() throws {
        XCTAssertEqual(viewModel.cityName, "Brisbane")
        XCTAssertEqual(viewModel.temperature, "21.19 °C")
    }
}

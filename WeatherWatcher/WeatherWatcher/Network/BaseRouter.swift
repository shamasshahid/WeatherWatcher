//
//  BaseRouter.swift
//  WeatherWatcher
//
//  Created by Shamas on 19/9/20.
//

import Foundation

/// Implements Routable protocol and is used to get the urlRequest
struct BaseRouter: Routable {
    
    enum QueryItemsKeys: String {
        case id
        case appID = "APPID"
        case units
    }

    var cityIDs: [Int32] = []
    
    var methodType: HTTPType {
        return .GET
    }
    
    var scheme: RoutableScheme {
        return .http
    }
    
    // perhaps can be moved to info.plist
    var baseURL: String {
        return "api.openweathermap.org"
    }
    
    var path: String {
        return "/data/2.5/group"
    }
    
    var queryItems: [URLQueryItem] {
        return [URLQueryItem(name: QueryItemsKeys.appID.rawValue, value: AppConfig.WEATHER_API_KEY),
                URLQueryItem(name: QueryItemsKeys.id.rawValue, value: cityIDs.map(String.init).joined(separator: ",")),
                URLQueryItem(name: QueryItemsKeys.units.rawValue, value: "metric")]
    }
    
    var headers: [String : Any] {
        return [:]
    }
    
    
    /// Creates a URLRequest object using the implemented Routable protocol
    /// - Throws: RouteError
    /// - Returns: URLRequest
    func asURLRequest() throws -> URLRequest {
        
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = baseURL
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else{
            throw RouteError.invalidRoute
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = methodType.rawValue
        
        for headerField in headers.keys {
            request.setValue(headers[headerField] as? String, forHTTPHeaderField: headerField)
        }
        
        return request
    }
}

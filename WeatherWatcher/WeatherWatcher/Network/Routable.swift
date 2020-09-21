//
//  Routable.swift
//  WeatherWatcher
//
//  Created by Shamas on 19/9/20.
//

import Foundation

/// scheme enum for Routable
enum RoutableScheme: String {
    case https
    case http
}

/// Routable conversion error
enum RouteError: Error {
    case invalidRoute
}

enum HTTPType : String {
    case GET
    case POST
    case PUT
    case DELETE
}


/// Routable protocol which defines the requirements to determine the request
protocol Routable {
    
    var cityIDs: [Int32] { get set }
    
    var methodType: HTTPType { get }
    var scheme: RoutableScheme { get }
    var baseURL: String { get }
    var path: String { get }
    
    var queryItems: [URLQueryItem] { get }
    var headers: [String : Any] { get }
    
    func asURLRequest() throws -> URLRequest
}

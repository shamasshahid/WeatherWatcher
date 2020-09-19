//
//  WeatherService.swift
//  WeatherWatcher
//
//  Created by Shamas on 19/9/20.
//

import Foundation

/// ConversionService which implements WebService and is used to fetch data from the backend
class WeatherService: WebService {
    
    let session = URLSession.shared
    
    func fetch(urlRequest: Routable, completionHandler: @escaping (Result<WeatherResponse, ServiceError>) -> Void) {
        
        do {
            let task = try session.dataTask(with: urlRequest.asURLRequest(), completionHandler: { (dataResponse, responseObject, error) in
                
                guard let data = dataResponse else {
                    completionHandler(.failure(.checkNetworkMaybe))
                    return
                }

                do {
                    let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    completionHandler(.success(response))
                } catch {
                    // return parsing failed error
                    completionHandler(.failure(.invalidResponseStructure))
                }
            })
            task.resume()
        } catch {
            completionHandler(.failure(.invalidURL))
        }
    }
}

//
//  ServiceAPIRouter.swift
//  WeatherApp
//
//  Created by Vika on 7/30/19.
//  Copyright © 2019 Vika. All rights reserved.
//

import Alamofire

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}

protocol ServiceAPIRouter: URLRequestConvertible {
    var hostURL: String! { get }
    var path: String { get }
    func asURLRequest() throws -> URLRequest
}

extension ServiceAPIRouter {
    var hostURL: String! {
        return "https://api.openweathermap.org/data/2.5/weather?"
    }
    
    var method: HTTPMethod? {
        return .get
    }
    
    func asURLRequest() throws -> URLRequest {
        if let url = URL(string: self.hostURL.appending(self.path)) {
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.get.rawValue
            request.setValue("application/json;", forHTTPHeaderField: "Content-Type")
            
            return request
        }
        return URLRequest(url: URL(string: "")!)
    }
}

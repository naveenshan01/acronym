//
//  APISession.swift
//  Acronym
//
//  Created by Naveen Shan on 10/23/21.
//

import Foundation

/// Protocol which helps to inject **URLSession**.
protocol APISession {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> APISessionDataTask
}

/// Protocol which helps to inject **URLSessionDataTask**.
protocol APISessionDataTask {
    var state: URLSessionTask.State { get }
    
    func resume()
    func cancel()
}

/// Extend URLSession with APISession.
extension URLSession: APISession {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> APISessionDataTask {
        return (dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask)
    }
}

/// Extend URLSessionDataTask with APISessionDataTask.
extension URLSessionDataTask: APISessionDataTask { }

/// Helper method for creating default parameters in func declaration.
extension URLSession {
    class var `default`: URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15.0
        return URLSession(configuration: config)
    }
}

//
//  MockURLSession.swift
//  AcronymTests
//
//  Created by Naveen Shan on 10/23/21.
//

import Foundation
@testable import Acronym

final class MockAPISessionDataTask: APISessionDataTask {
    var state: URLSessionTask.State = .completed
    
    var isResumeExecuted = false
    var isCancelExecuted = false
    
    func resume() {
        isResumeExecuted = true
        state = .running
    }
    
    func cancel() {
        isCancelExecuted = true
        state = .canceling
    }
}

final class MockURLSession {
    enum MethodHandler {
        case dataTaskWithRequest(_ request: URLRequest)
    }
    private(set) var executedMethods: [MethodHandler] = []
    
    public func reset() {
        executedMethods = []
    }
    
    var mockResponse: (Data?, URLResponse?, Error?)
    var mockDataTask = MockAPISessionDataTask()
}

extension MockURLSession: APISession {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> APISessionDataTask {
        executedMethods.append(.dataTaskWithRequest(request))
        completionHandler(self.mockResponse.0, self.mockResponse.1, self.mockResponse.2)
        return mockDataTask
    }
}

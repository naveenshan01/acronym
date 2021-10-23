//
//  MockSearchService.swift
//  AcronymTests
//
//  Created by Naveen Shan on 10/23/21.
//

import Foundation
@testable import Acronym

enum MockError: Error {
    case testError
}

final class MockSearchService {
    enum MethodHandler {
        case searchAcronym(_ text: String)
    }
    private(set) var executedMethods: [MethodHandler] = []
    
    public func reset() {
        executedMethods = []
    }
    
    var mockResult: Result<[Longform], Error> = .failure(MockError.testError)
}

extension MockSearchService: SearchServicing {
    func searchAcronym(_ text: String, completion: @escaping (Result<[Longform], Error>) -> ()) {
        executedMethods.append(.searchAcronym(text))
        completion(mockResult)
    }
}

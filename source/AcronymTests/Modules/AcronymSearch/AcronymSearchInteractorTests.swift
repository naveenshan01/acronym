//
//  AcronymSearchInteractorTests.swift
//  AcronymTests
//
//  Created by Naveen Shan on 10/23/21.
//

import XCTest
@testable import Acronym

final class AcronymSearchInteractorTests: XCTestCase {
    var interactor: AcronymSearchInteractor?
    var mockSearchService: MockSearchService?

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let mockSearchService = MockSearchService()
        interactor = AcronymSearchInteractor(searchService: mockSearchService)
        self.mockSearchService = mockSearchService
    }

    override func tearDownWithError() throws {
        interactor = nil
        mockSearchService = nil
        try super.tearDownWithError()
    }
    
    func testSearchAcronym() throws {
        var responseReived = false
        
        let expect = expectation(description: "API Call")
        expect.expectedFulfillmentCount = 2
        
        interactor?.searchAcronym(text: "", completion: { result in
            responseReived = true
            expect.fulfill()
        })
        
        XCTAssertTrue(responseReived)
        XCTAssertEqual(mockSearchService?.executedMethods.count, 1)
        
        guard case let .searchAcronym(text1) = mockSearchService?.executedMethods.first else {
            XCTFail("Expected Method not executed...")
            return
        }
        XCTAssertEqual(text1, "")
        
        interactor?.searchAcronym(text: "NS", completion: { result in
            responseReived = true
            expect.fulfill()
        })
        
        XCTAssertTrue(responseReived)
        XCTAssertEqual(mockSearchService?.executedMethods.count, 2)
        
        guard case let .searchAcronym(text2) = mockSearchService?.executedMethods.last else {
            XCTFail("Expected Method not executed...")
            return
        }
        XCTAssertEqual(text2, "NS")
        
        wait(for: [expect], timeout: 10.0)
    }
}

extension AcronymSearchInteractorTests {
    final class MockAcronymSearchInteractor: AcronymSearchInteractable {
        enum MethodHandler {
            case searchAcronym(_ text: String)
        }
        private(set) var executedMethods: [MethodHandler] = []
        
        public func reset() {
            executedMethods = []
        }
        
        var mockResult: Result<[Longform], Error> = .failure(MockError.testError)
        
        func searchAcronym(text: String, completion: @escaping (Result<[Longform], Error>) -> ()) {
            executedMethods.append(.searchAcronym(text))
            completion(mockResult)
        }
    }
}

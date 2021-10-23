//
//  SearchServiceTests.swift
//  AcronymTests
//
//  Created by Naveen Shan on 10/23/21.
//

import XCTest
@testable import Acronym

final class SearchServiceTests: XCTestCase {
    var searchService: SearchService?
    var mockURLSession: MockURLSession?

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let apiSession = MockURLSession()
        searchService = SearchService(urlSession: apiSession)
        
        self.mockURLSession = apiSession
    }

    override func tearDownWithError() throws {
        searchService = nil
        mockURLSession = nil
        try super.tearDownWithError()
    }

    func testSearchAcronymForError() throws {
        var receivedResult: Result<[Longform], Error>?
        mockURLSession?.mockResponse = (nil, nil, MockError.testError)
        
        let expect = expectation(description: "Wait for Service")
        searchService?.searchAcronym("NS") { result in
            receivedResult = result
            expect.fulfill()
        }
    
        wait(for: [expect], timeout: 10.0)
        
        XCTAssertNotNil(receivedResult)
        XCTAssertEqual(mockURLSession?.executedMethods.count, 1)
        
        guard case let .failure(error) = receivedResult else {
            XCTFail("Expected method not execute...")
            return
        }
        XCTAssertEqual(error.localizedDescription, MockError.testError.localizedDescription)
    }
    
    func testSearchAcronymNoData() throws {
        var receivedResult: Result<[Longform], Error>?
        mockURLSession?.mockResponse = (nil, nil, nil)
        
        let expect = expectation(description: "Wait for Service")
        searchService?.searchAcronym("NS") { result in
            receivedResult = result
            expect.fulfill()
        }
    
        wait(for: [expect], timeout: 10.0)
        
        XCTAssertNotNil(receivedResult)
        XCTAssertEqual(mockURLSession?.executedMethods.count, 1)
        
        guard case let .failure(error) = receivedResult else {
            XCTFail("Expected method not execute...")
            return
        }
        XCTAssertEqual(error.localizedDescription, SearchService.SearchError.noResultFound.localizedDescription)
    }
    
    func testSearchAcronymWithNonValidResponse() throws {
        let data = "String to Data".data(using: .utf8)
        var receivedResult: Result<[Longform], Error>?
        mockURLSession?.mockResponse = (data, nil, nil)
        
        let expect = expectation(description: "Wait for Service")
        searchService?.searchAcronym("NS") { result in
            receivedResult = result
            expect.fulfill()
        }
    
        wait(for: [expect], timeout: 10.0)
        
        XCTAssertNotNil(receivedResult)
        XCTAssertEqual(mockURLSession?.executedMethods.count, 1)
        
        guard case let .failure(error) = receivedResult else {
            XCTFail("Expected method not execute...")
            return
        }
        XCTAssertEqual(error.localizedDescription, SearchService.SearchError.noResultFound.localizedDescription)
    }
    
    func testSearchAcronymValidResponse() throws {
        let response = [SearchResponse(lfs: [Longform(lf: "nonstimulated", since: 1996)])]
        let data = try JSONEncoder().encode(response)
        var receivedResult: Result<[Longform], Error>?
        mockURLSession?.mockResponse = (data, nil, nil)
        
        let expect = expectation(description: "Wait for Service")
        searchService?.searchAcronym("NS") { result in
            receivedResult = result
            expect.fulfill()
        }
    
        wait(for: [expect], timeout: 10.0)
        
        XCTAssertNotNil(receivedResult)
        XCTAssertEqual(mockURLSession?.executedMethods.count, 1)
    }
    
    func testSearchAcronymInValidSearchText() throws {
        let response = [SearchResponse(lfs: [Longform(lf: "nonstimulated", since: 1996)])]
        let data = try JSONEncoder().encode(response)
        var receivedResult: Result<[Longform], Error>?
        mockURLSession?.mockResponse = (data, nil, nil)
        
        let expect = expectation(description: "Wait for Service")
        searchService?.searchAcronym("/%20%23") { result in
            receivedResult = result
            expect.fulfill()
        }
    
        wait(for: [expect], timeout: 10.0)
        
        XCTAssertNotNil(receivedResult)
        XCTAssertEqual(mockURLSession?.executedMethods.count, 1)
    }
}

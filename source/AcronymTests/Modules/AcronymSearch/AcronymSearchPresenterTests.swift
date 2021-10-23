//
//  AcronymSearchPresenterTests.swift
//  AcronymTests
//
//  Created by Naveen Shan on 10/23/21.
//

import XCTest
@testable import Acronym

final class AcronymSearchPresenterTests: XCTestCase {
    var presenter: AcronymSearchPresenter?
    var mockAcronymSearchRouter: AcronymSearchRouterTests.MockAcronymSearchRouter?
    var mockAcronymSearchView: AcronymSearchViewControllerTests.MockAcronymSearchView?
    var mockAcronymSearchInteractor: AcronymSearchInteractorTests.MockAcronymSearchInteractor?

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let mockAcronymSearchRouter = AcronymSearchRouterTests.MockAcronymSearchRouter()
        let mockAcronymSearchView = AcronymSearchViewControllerTests.MockAcronymSearchView()
        let mockAcronymSearchInteractor = AcronymSearchInteractorTests.MockAcronymSearchInteractor()
        
        presenter = AcronymSearchPresenter(view: mockAcronymSearchView, interactor: mockAcronymSearchInteractor, router: mockAcronymSearchRouter)
        
        self.mockAcronymSearchView = mockAcronymSearchView
        self.mockAcronymSearchRouter = mockAcronymSearchRouter
        self.mockAcronymSearchInteractor = mockAcronymSearchInteractor
    }

    override func tearDownWithError() throws {
        presenter = nil
        mockAcronymSearchView = nil
        mockAcronymSearchRouter = nil
        mockAcronymSearchInteractor = nil
        try super.tearDownWithError()
    }
    

    func testSearchAcronymWithEmptyText() throws {
        presenter?.searchAcronym(text: "")
        
        XCTAssertEqual(mockAcronymSearchView?.executedMethods.count, 1)
        XCTAssertEqual(mockAcronymSearchInteractor?.executedMethods.count, 0)
        
        guard case let .displayModel(viewModel) = mockAcronymSearchView?.executedMethods.first else {
            XCTFail("Expected Method not executed...")
            return
        }
        // Means it's clear the result.
        XCTAssertEqual(viewModel.results.count, 0)
    }
    
    func testSearchAcronymWithValidTextButFailure() throws {
        presenter?.searchAcronym(text: "NS")
        
        XCTAssertEqual(mockAcronymSearchInteractor?.executedMethods.count, 1)
        
        guard case let .searchAcronym(text) = mockAcronymSearchInteractor?.executedMethods.first else {
            XCTFail("Expected Method not executed...")
            return
        }
        XCTAssertEqual(text, "NS")
        
        // Clearing results and display error.
        XCTAssertEqual(mockAcronymSearchView?.executedMethods.count, 2)
        guard case let .displayModel(viewModel) = mockAcronymSearchView?.executedMethods.first else {
            XCTFail("Expected Method not executed...")
            return
        }
        // Mocked result is an error, so we clear the results.
        XCTAssertEqual(viewModel.results.count, 0)
        
        guard case let .display(error) = mockAcronymSearchView?.executedMethods.last else {
            XCTFail("Expected Method not executed...")
            return
        }
        // The error is not empty result, so we need to show error alert.
        XCTAssertNil(error as? SearchService.SearchError)
    }
    
    func testSearchAcronymWithValidTextButNoResultsFailure() throws {
        mockAcronymSearchInteractor?.mockResult = .failure(SearchService.SearchError.noResultFound)
        
        presenter?.searchAcronym(text: "NS")
        
        XCTAssertEqual(mockAcronymSearchInteractor?.executedMethods.count, 1)
        
        guard case let .searchAcronym(text) = mockAcronymSearchInteractor?.executedMethods.first else {
            XCTFail("Expected Method not executed...")
            return
        }
        XCTAssertEqual(text, "NS")
        
        // Not displaying error only clearing results.
        XCTAssertEqual(mockAcronymSearchView?.executedMethods.count, 1)
        guard case let .displayModel(viewModel) = mockAcronymSearchView?.executedMethods.first else {
            XCTFail("Expected Method not executed...")
            return
        }
        // Mocked result is an error, so we clear the results.
        XCTAssertEqual(viewModel.results.count, 0)
    }
    
    func testSearchAcronymWithValidTextWithSuccess() throws {
        let response = [Longform(lf: "nonstimulated", since: 1996)]
        mockAcronymSearchInteractor?.mockResult = .success(response)
        
        presenter?.searchAcronym(text: "NS")
        
        XCTAssertEqual(mockAcronymSearchInteractor?.executedMethods.count, 1)
        
        guard case let .searchAcronym(text) = mockAcronymSearchInteractor?.executedMethods.first else {
            XCTFail("Expected Method not executed...")
            return
        }
        XCTAssertEqual(text, "NS")
        
        // Not displaying error only clearing results.
        XCTAssertEqual(mockAcronymSearchView?.executedMethods.count, 1)
        guard case let .displayModel(viewModel) = mockAcronymSearchView?.executedMethods.first else {
            XCTFail("Expected Method not executed...")
            return
        }
        
        XCTAssertEqual(viewModel.results.count, 1)
        let firstElement = viewModel.results.first
        XCTAssertEqual(firstElement?.title, "1. Nonstimulated")
        XCTAssertEqual(firstElement?.detail, "since 1996")
    }
}

extension AcronymSearchPresenterTests {
    final class MockAcronymSearchPresenter: AcronymSearchPresentable {
        enum MethodHandler {
            case searchAcronym(_ text: String)
        }
        private(set) var executedMethods: [MethodHandler] = []
        
        public func reset() {
            executedMethods = []
        }
        
        func searchAcronym(text: String) {
            executedMethods.append(.searchAcronym(text))
        }
    }
}

//
//  AcronymSearchViewControllerTests.swift
//  AcronymTests
//
//  Created by Naveen Shan on 10/23/21.
//

import XCTest
@testable import Acronym

final class AcronymSearchViewControllerTests: XCTestCase {
    var viewController: AcronymSearchViewController?
    var mockAlertView: MockAlertView?
    var mockAcronymSearchPresenter: AcronymSearchPresenterTests.MockAcronymSearchPresenter?

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let mockAlertView = MockAlertView()
        mockAcronymSearchPresenter = AcronymSearchPresenterTests.MockAcronymSearchPresenter()
        
        viewController = AcronymSearchViewController()
        viewController?.presenter = mockAcronymSearchPresenter
        
        // Mock the Alert view to skip display alert during test runs
        viewController?.alertView = mockAlertView
        self.mockAlertView = mockAlertView
        
        // To load the view
        _ = viewController?.view
    }

    override func tearDownWithError() throws {
        mockAlertView = nil
        viewController = nil
        mockAcronymSearchPresenter = nil
        try super.tearDownWithError()
    }

    func testInitialization() throws {
        XCTAssertNotNil(viewController?.presenter)
        XCTAssertNotNil(viewController?.searchBar)
        XCTAssertNotNil(viewController?.tableView)
        XCTAssertNotNil(viewController?.activityIndicator)
        
        XCTAssertEqual(viewController?.title, "Search Acronym")
    }
    
    func testSearchAcronym() throws {
        viewController?.searchAcronym(text: "NS")
        
        guard case let .searchAcronym(text) = mockAcronymSearchPresenter?.executedMethods.first else {
            XCTFail("Expected Method not executed...")
            return
        }
        XCTAssertEqual(text, "NS")
        XCTAssertTrue(viewController?.activityIndicator.isAnimating ?? false)
    }
    
    func testDisplayViewModel() throws {
        viewController?.activityIndicator.startAnimating()
        
        let cellViewModel = AcronymSearchCellViewModel(title: "nephrotic syndrome", detail: "1967")
        let firstViewModel = AcronymSearchViewModel(results: [cellViewModel])
        viewController?.display(firstViewModel)
        
        let expect = expectation(description: "Wait for Main Thread")
        DispatchQueue.main.async {
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10.0)
        
        // Once results availbale, view needs to stop animating activity indicator
        // update the view model and refresh.
        XCTAssertFalse(viewController?.activityIndicator.isAnimating ?? true)
        XCTAssertEqual(viewController?.viewModel.results.count, 1)
        
        viewController?.activityIndicator.startAnimating()
        viewController?.display(AcronymSearchViewModel())
        
        let expect1 = expectation(description: "Wait for Main Thread")
        DispatchQueue.main.async {
            expect1.fulfill()
        }
        wait(for: [expect1], timeout: 10.0)
        
        // Once results availbale, view needs to stop animating activity indicator
        // update the view model and refresh.
        XCTAssertFalse(viewController?.activityIndicator.isAnimating ?? true)
        XCTAssertEqual(viewController?.viewModel.results.count, 0)
    }
    
    func testDisplayError() throws {
        viewController?.activityIndicator.startAnimating()
        
        viewController?.display(MockError.testError)
        
        let expect = expectation(description: "Wait for Main Thread")
        DispatchQueue.main.async {
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10.0)
        
        // If there is any error, view needs to stop animating activity indicator
        // display the error in alert view.
        XCTAssertFalse(viewController?.activityIndicator.isAnimating ?? true)
        XCTAssertEqual(mockAlertView?.executedMethods.count, 1)
        
        guard case let .showAlert(title, message, actions, on) = mockAlertView?.executedMethods.first else {
            XCTFail("Expected Method not executed...")
            return
        }
        XCTAssertEqual(title, "Error")
        XCTAssertEqual(message, MockError.testError.localizedDescription)
        XCTAssertEqual(actions, nil)
        XCTAssertEqual(on, viewController)
    }
}

extension AcronymSearchViewControllerTests {
    func testNumberOfRowsInSection() throws {
        guard let tableView = viewController?.tableView else {
            XCTFail("Subview not found...")
            return
        }
        var result = viewController?.tableView(tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(result, 0)
        
        let cellViewModel = AcronymSearchCellViewModel(title: "nephrotic syndrome", detail: "1967")
        let firstViewModel = AcronymSearchViewModel(results: [cellViewModel])
        viewController?.display(firstViewModel)
        
        let expect = expectation(description: "Wait for Main Thread")
        DispatchQueue.main.async {
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10.0)
        
        result = viewController?.tableView(tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(result, 1)
    }
    
    func testCellForRowAtIndexPaths() throws {
        guard let tableView = viewController?.tableView else {
            XCTFail("Subview not found...")
            return
        }
        let cellViewModel = AcronymSearchCellViewModel(title: "nephrotic syndrome", detail: "1967")
        let firstViewModel = AcronymSearchViewModel(results: [cellViewModel])
        viewController?.display(firstViewModel)
        
        let expect = expectation(description: "Wait for Main Thread")
        DispatchQueue.main.async {
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10.0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = viewController?.tableView(tableView, cellForRowAt: indexPath)
        XCTAssertNotNil(cell as? AcronymSearchViewController.AcronymSearchCell)
        XCTAssertEqual(cell?.textLabel?.text, "nephrotic syndrome")
        XCTAssertEqual(cell?.detailTextLabel?.text, "1967")
    }
}

extension AcronymSearchViewControllerTests {
    func testSearchBarCancelButtonHandling() throws {
        guard let searchBar = viewController?.searchBar else {
            XCTFail("Subview not found...")
            return
        }
        XCTAssertFalse(searchBar.showsCancelButton)
        
        viewController?.searchBarTextDidBeginEditing(searchBar)
        XCTAssertTrue(searchBar.showsCancelButton)
        //Hides 'Cancel' when search started
        viewController?.searchBarTextDidEndEditing(searchBar)
        XCTAssertFalse(searchBar.showsCancelButton)
        
        viewController?.searchBarTextDidBeginEditing(searchBar)
        XCTAssertTrue(searchBar.showsCancelButton)
        //Hides 'Cancel' when search button tapped
        viewController?.searchBarSearchButtonClicked(searchBar)
        XCTAssertFalse(searchBar.showsCancelButton)
        
        viewController?.searchBarTextDidBeginEditing(searchBar)
        XCTAssertTrue(searchBar.showsCancelButton)
        viewController?.searchBarCancelButtonClicked(searchBar)
        //Hides 'Cancel' when cancel button tapped
        XCTAssertFalse(searchBar.showsCancelButton)
    }
    
    func testSearchBarTextDidChange() throws {
        guard let searchBar = viewController?.searchBar else {
            XCTFail("Subview not found...")
            return
        }
        
        XCTAssertFalse(viewController?.activityIndicator.isAnimating ?? true)
        
        viewController?.searchBar(searchBar, textDidChange: "NS")
        
        let expect = expectation(description: "Wait for Main Thread")
        DispatchQueue.main.async {
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10.0)
        
        guard case let .searchAcronym(text) = mockAcronymSearchPresenter?.executedMethods.first else {
            XCTFail("Expected Method not executed...")
            return
        }
        XCTAssertEqual(text, "NS")
        XCTAssertTrue(viewController?.activityIndicator.isAnimating ?? false)
    }
}

extension AcronymSearchViewControllerTests {
    final class MockAcronymSearchView: AcronymSearchViewiable {
        enum MethodHandler {
            case display(_ error: Error)
            case displayModel(_ viewModel: AcronymSearchViewModel)
        }
        private(set) var executedMethods: [MethodHandler] = []
        
        public func reset() {
            executedMethods = []
        }
        
        
        func display(_ error: Error) {
            executedMethods.append(.display(error))
        }
        
        func display(_ viewModel: AcronymSearchViewModel) {
            executedMethods.append(.displayModel(viewModel))
        }
    }
}

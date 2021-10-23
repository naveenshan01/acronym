//
//  AcronymSearchRouterTests.swift
//  AcronymTests
//
//  Created by Naveen Shan on 10/23/21.
//

import XCTest
@testable import Acronym

final class AcronymSearchRouterTests: XCTestCase {
    var router: AcronymSearchRouter?

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        router = AcronymSearchRouter()
    }

    override func tearDownWithError() throws {
        router = nil
        try super.tearDownWithError()
    }

    func testAcronymSearchViewController() throws {
        let viewController = router?.acronymSearchViewController()
        XCTAssertNotNil(viewController)
        
        guard let acronymSearchViewController = viewController as? AcronymSearchViewController else {
            throw NSError()
        }
        XCTAssertNil(acronymSearchViewController.presenter as? AcronymSearchViewiable)
    }
}

extension AcronymSearchRouterTests {
    final class MockAcronymSearchRouter: AcronymSearchRoutable {
        enum MethodHandler {
            case acronymSearchViewController
        }
        private(set) var executedMethods: [MethodHandler] = []
        
        public func reset() {
            executedMethods = []
        }
        
        func acronymSearchViewController() -> UIViewController {
            executedMethods.append(.acronymSearchViewController)
            return UIViewController()
        }
    }
}

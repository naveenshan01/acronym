//
//  MockAlertView.swift
//  AcronymTests
//
//  Created by Naveen Shan on 10/23/21.
//

import UIKit
@testable import Acronym

final class MockAlertView {
    enum MethodHandler {
        case showAlert(title: String?, message: String?, actions: [UIAlertAction]?, on: UIViewController)
    }
    private(set) var executedMethods: [MethodHandler] = []
    
    public func reset() {
        executedMethods = []
    }
}

extension MockAlertView: AlertViewable {
    func showAlert(title: String?, message: String?, on: UIViewController) {
        // In real implementatio we show OK `detructive` button if actions is empty.
        executedMethods.append(.showAlert(title: title, message: message, actions: nil, on: on))
    }
    
    func showAlert(title: String?, message: String?, actions: [UIAlertAction]?, on: UIViewController) {
        executedMethods.append(.showAlert(title: title, message: message, actions: actions, on: on))
    }
}

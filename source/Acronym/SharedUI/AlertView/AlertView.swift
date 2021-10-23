//
//  AlertView.swift
//  Acronym
//
//  Created by Naveen Shan on 10/23/21.
//

import UIKit

/// Protocol which provides interface to show UIAlertController.
protocol AlertViewable {
    func showAlert(title: String?, message: String?, on: UIViewController)
    func showAlert(title: String?, message: String?, actions: [UIAlertAction]?, on: UIViewController)
}

/// Class helps to show Alerts
final class AlertView {
    public static var shared = AlertView()
}

extension AlertView: AlertViewable {
    public func showAlert(title: String?, message: String?, on: UIViewController) {
        showAlert(title: title, message: message, actions: nil, on: on)
    }
    
    func showAlert(title: String? = nil, message: String? = nil, actions: [UIAlertAction]? = nil, on: UIViewController) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            if actions?.isEmpty ?? true {
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            actions?.forEach { alertController.addAction($0) }
            
            let topViewController = on
            topViewController.present(alertController, animated: true)
        }
    }
}

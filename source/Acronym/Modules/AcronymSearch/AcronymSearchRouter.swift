//
//  AcronymSearchRouter.swift
//  Acronym
//
//  Created by Naveen Shan on 10/23/21.
//

import UIKit

protocol AcronymSearchRoutable {
    func acronymSearchViewController() -> UIViewController
}

final class AcronymSearchRouter {
    
}

extension AcronymSearchRouter: AcronymSearchRoutable {
    func acronymSearchViewController() -> UIViewController {
        let searchService = SearchService()
        let interactor = AcronymSearchInteractor(searchService: searchService)
        let viewController = AcronymSearchViewController()
        
        let presenter = AcronymSearchPresenter(view: viewController, interactor: interactor, router: self)
        viewController.presenter = presenter
        
        return viewController
    }
}

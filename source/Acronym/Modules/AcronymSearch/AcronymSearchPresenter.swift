//
//  AcronymSearchPresenter.swift
//  Acronym
//
//  Created by Naveen Shan on 10/23/21.
//

import Foundation

protocol AcronymSearchPresentable {
    func searchAcronym(text: String)
}

final class AcronymSearchPresenter {
    let router: AcronymSearchRoutable
    weak var view: AcronymSearchViewiable?
    let interactor: AcronymSearchInteractable
    
    init(view: AcronymSearchViewiable, interactor: AcronymSearchInteractable, router: AcronymSearchRoutable) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension AcronymSearchPresenter: AcronymSearchPresentable {
    func searchAcronym(text: String) {
        guard !text.isEmpty else {
            // [NS] To clear the result.
            view?.display(AcronymSearchViewModel())
            return
        }
        interactor.searchAcronym(text: text) { [weak self] result in
            switch result {
            case .success(let response):
                let results = response.enumerated().map {
                    AcronymSearchCellViewModel(title: "\($0 + 1). \($1.lf.capitalized)", detail: "since \($1.since)")
                }
                self?.view?.display(AcronymSearchViewModel(results: results))
            case .failure(let error):
                // [NS] To clear the result.
                self?.view?.display(AcronymSearchViewModel())
                // [NS Ignoring custom search error such as no results
                guard (error as? SearchService.SearchError) == nil else { return }
                // [NS] Map the error to readable/localized user friendly error format.
                self?.view?.display(error)
            }
        }
    }
}

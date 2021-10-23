//
//  AcronymSearchInteractor.swift
//  Acronym
//
//  Created by Naveen Shan on 10/23/21.
//

import Foundation

protocol AcronymSearchInteractable {
    func searchAcronym(text: String, completion: @escaping (Result<[Longform], Error>) -> ())
}

final class AcronymSearchInteractor {
    let searchService: SearchServicing
    
    init(searchService: SearchServicing) {
        self.searchService = searchService
    }
}

extension AcronymSearchInteractor: AcronymSearchInteractable {
    func searchAcronym(text: String, completion: @escaping (Result<[Longform], Error>) -> ()) {
        searchService.searchAcronym(text, completion: completion)
    }
}

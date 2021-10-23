//
//  AcronymSearchViewModel.swift
//  Acronym
//
//  Created by Naveen Shan on 10/23/21.
//

import Foundation

struct AcronymSearchViewModel {
    let results: [AcronymSearchCellViewModel]
    
    init(results: [AcronymSearchCellViewModel] = [AcronymSearchCellViewModel]()) {
        self.results = results
    }
}

struct AcronymSearchCellViewModel {
    let title: String
    let detail: String
}

//
//  SearchService.swift
//  Acronym
//
//  Created by Naveen Shan on 10/23/21.
//

import Foundation

protocol SearchServicing {
    func searchAcronym(_ text: String, completion: @escaping (Result<[Longform], Error>) -> ())
}

final class SearchService {
    let decoder = JSONDecoder()
    let urlSession : APISession
    
    init(urlSession : APISession = URLSession.default) {
        self.urlSession = urlSession
    }
    
    enum SearchError: Error {
        case internalError
        case noResultFound
    }
}

extension SearchService: SearchServicing {
    func searchAcronym(_ text: String, completion: @escaping (Result<[Longform], Error>) -> ()) {
        let urlString = "http://www.nactem.ac.uk/software/acromine/dictionary.py"
        
        var urlComponent = URLComponents(string: urlString)
        urlComponent?.queryItems = [URLQueryItem(name: "sf", value: text)]
        guard let url = urlComponent?.url else {
            completion(.failure(SearchError.internalError))
            return
        }
        
        urlSession.dataTask(with: URLRequest(url: url)) { [weak self] data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data,
                  let response = try? self?.decoder.decode([SearchResponse].self, from: data),
                  let result = response.first?.lfs else {
                completion(.failure(SearchError.noResultFound))
                return
            }
            // [NS] couldn't find an use case return more
            // than one result in result array, extent the logic later as needed.
            // `let result = response.first?.lfs`
            completion(.success(result))
        }.resume()
    }
}

// MARK:-  Models

struct SearchResponse: Codable {
    let lfs: [Longform]
}

struct Longform: Codable {
    let lf: String // Long Form Text
    let since: Int
}

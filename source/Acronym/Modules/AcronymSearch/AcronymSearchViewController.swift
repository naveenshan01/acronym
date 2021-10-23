//
//  AcronymSearchViewController.swift
//  Acronym
//
//  Created by Naveen Shan on 10/23/21.
//

import UIKit

protocol AcronymSearchViewiable: AnyObject {
    func display(_ error: Error)
    func display(_ viewModel: AcronymSearchViewModel)
}

final class AcronymSearchViewController: UIViewController {
    var presenter: AcronymSearchPresentable?
    var viewModel = AcronymSearchViewModel()
    var alertView: AlertViewable = AlertView.shared
    
    // MARK: - SubViews
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect.zero)
        searchBar.placeholder = "Search Acronym"
        searchBar.searchTextField.clearButtonMode = .whileEditing
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44.0
        tableView.keyboardDismissMode = .onDrag
        tableView.register(AcronymSearchCell.self, forCellReuseIdentifier: "SearchCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(frame: CGRect.zero)
        indicatorView.hidesWhenStopped = true
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
        layoutViews()
    }
    
    private func initializeViews() {
        title = "Search Acronym"
        view.backgroundColor = UIColor.systemGroupedBackground
        
        searchBar.delegate = self
        view.addSubview(searchBar)
        view.addSubview(tableView)
        searchBar.addSubview(activityIndicator)
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            activityIndicator.rightAnchor.constraint(equalTo: searchBar.rightAnchor, constant: -120.0),
        ])
    }
}

// MARK: - View Methods

extension AcronymSearchViewController {
    func searchAcronym(text: String) {
        activityIndicator.startAnimating()
        presenter?.searchAcronym(text: text)
    }
}

// MARK: - View Protocol Methods

extension AcronymSearchViewController: AcronymSearchViewiable {
    func display(_ viewModel: AcronymSearchViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.viewModel = viewModel
            self?.tableView.reloadData()
        }
    }
    
    func display(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.activityIndicator.stopAnimating()
            strongSelf.searchBar.resignFirstResponder()
            strongSelf.alertView.showAlert(title: "Error", message: error.localizedDescription, actions: nil, on: strongSelf)
        }
    }
}

// MARK: - UITableViewDataSource

extension AcronymSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? AcronymSearchCell else {
            return UITableViewCell()
        }
        cell.customize(viewModel.results[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AcronymSearchViewController: UITableViewDelegate {
}

// MARK: - UISearchBarDelegate

extension AcronymSearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchAcronym(text: searchText)
    }
}

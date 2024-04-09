//
//  ViewController.swift
//  CountriesInTheWorld
//
//  Created by Roderick Presswood on 12/1/23.
//

import UIKit


class CountriesTableViewController: UIViewController {
    
    private let viewModel = CountriesViewModel(networkManager: NetworkManager())
    
    private lazy var pullToRefresh = UIRefreshControl()
    
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search countries/cities"
        searchBar.showsCancelButton = true
        return searchBar
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomCountriesTableViewCell.self, forCellReuseIdentifier: CustomCountriesTableViewCell.reuseId)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        tableView.dataSource = self
        searchBar.delegate = self
        getCountires()
    }
    
    func getCountires() {
        viewModel.getCountries(url: url) { [weak self] result in
                switch result {
                case .success(_):
                    self?.tableView.reloadData()
                case .failure(_):
                    self?.showErrorAlert()
                }
            
        }
    }
    

    
    private func setup() {
        setUpPullToRefresh()
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension CountriesTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredCountries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCountriesTableViewCell.reuseId,for: indexPath) as? CustomCountriesTableViewCell
        guard let country = viewModel.filteredCountries?[indexPath.row] else { return UITableViewCell() }
        cell?.setup(with: country)
        return cell ?? UITableViewCell()
    }
}

extension CountriesTableViewController {
    func showErrorAlert() {
        let alertControl = UIAlertController(title:"Error", message:"Api Failed, Pls try again", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title:"ok", style: .destructive, handler: nil)
        
        let retryAction = UIAlertAction(title:"Retry", style: .destructive) { [weak self] _ in
            self?.getCountires()
        }
        
        alertControl.addAction(okAction)
        alertControl.addAction(retryAction)
        
        self.present(alertControl, animated: true, completion: nil)
    }
    
    func setUpPullToRefresh() {
        tableView.refreshControl = pullToRefresh
        pullToRefresh.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh() {
        getCountires()
    }
}
extension CountriesTableViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.filterCountries(from: "")
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterCountries(from: searchText)
        tableView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

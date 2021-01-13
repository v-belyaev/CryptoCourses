//
//  ViewController.swift
//  CryptoCourses
//
//  Created by Владимир Беляев on 13.01.2021.
//

import UIKit
import Network

final class RatesViewController: UIViewController {

    // MARK: - Properties
    var rates: [Rate] = []

    // MARK: - Subviews
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.refreshControl = UIRefreshControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension RatesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: RateTableViewCell.identifier,
                for: indexPath) as? RateTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(rate: rates[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Private methods
extension RatesViewController {
    private func onViewDidLoad() {
        setupNavigationController()
        addSubviews()
        setupConstraints()
        setupTableView()
        loadRates()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 76
        tableView.register(UINib(nibName: "RateTableViewCell", bundle: nil), forCellReuseIdentifier: RateTableViewCell.identifier)
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.topItem?.title = "Rates"
    }
    
    private func loadRates(
        with currency: String = "usd",
        amount: Int = 100,
        using session: URLSession = .shared
    ) {
        session.configuration.waitsForConnectivity = true
        session.configuration.timeoutIntervalForResource = 300
        session.request(
            .rates(currency: currency, itemAmount: amount)
        ) {[unowned self] (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    self.rates = try JSONDecoder().decode([Rate].self, from: data)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch let decodeError {
                    print(decodeError)
                }
            }
        }
    }
    
    private func showFailuredAlert() {
        let title = "Connection error"
        let message = "Please, check your internet connection"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    @objc private func refresh() {
        loadRates()
        tableView.refreshControl?.endRefreshing()
    }
}

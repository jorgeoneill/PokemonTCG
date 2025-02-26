//
//  MainView.swift
//  PokemonTCG
//
//  Created by Jorge O'Neill on 24/02/2025.
//

import UIKit

final class MainView: UIView {
    
    private let searchBar = UISearchBar()
    private var tableView = UITableView()
    
    // Displays a message when the list is empty
    private let emptyListLabel = UILabel()
    
    private var viewModel: ViewModel
    
    // MARK: - Lifecycle
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupSubviews()
        setupConstraints()
        
        // Bind to view model updates
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.updateView()
            }
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupSubviews() {
        // Table view
        tableView.delegate = self
        tableView.dataSource = self
        // Dismisses the keyboard on scroll, if "Search" button is disabled.
        tableView.keyboardDismissMode = .onDrag
        tableView.register(CardCellView.self, forCellReuseIdentifier: CardCellView.identifier)
        addSubview(tableView)
        
        // Search bar
        searchBar.delegate = self
        searchBar.placeholder = viewModel.searchBarPlaceholder
        addSubview(searchBar)
        
        // Empty list message
        emptyListLabel.text = viewModel.emptyListMessage
        emptyListLabel.textAlignment = .center
        emptyListLabel.textColor = viewModel.emptyListMessageColor
        emptyListLabel.font = viewModel.emptyListMessageFont
        emptyListLabel.isHidden = true // Initially hidden
        addSubview(emptyListLabel)

    }
    
    private func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        emptyListLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyListLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        emptyListLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        emptyListLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func updateView() {
        tableView.reloadData()
        let hasItems = viewModel.numberOfItems > 0
        tableView.isHidden = !hasItems
        emptyListLabel.isHidden = hasItems
    }
}

// MARK: - Table view data source methods
extension MainView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardCellView.identifier, for: indexPath) as? CardCellView else {
            return UITableViewCell()
        }
        
        let cellViewModel = viewModel.cardCellViewModel(at: indexPath.row)
        cell.configure(with: cellViewModel)
        return cell
    }
}

// MARK: Table view delegate methods
extension MainView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.UI.cardCellViewHeight
    }
}

// MARK: Search bar delegate methods
extension MainView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchItems(with: searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Dismiss keyboard
    }
}

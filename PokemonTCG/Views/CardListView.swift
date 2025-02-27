//
//  CardListView.swift
//  PokemonTCG
//
//  Created by Jorge O'Neill on 24/02/2025.
//

import UIKit

final class CardListView: UIView {
    // MARK: - Private properties
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
        // Dismisses the keyboard on scroll, if Search button is disabled.
        tableView.keyboardDismissMode = .onDrag
        tableView.register(CardCellView.self, forCellReuseIdentifier: CardCellView.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        // Search bar
        searchBar.delegate = self
        searchBar.placeholder = viewModel.searchBarPlaceholder
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchBar)
        
        // Empty list message
        emptyListLabel.text = viewModel.emptyListMessage
        emptyListLabel.textAlignment = .center
        emptyListLabel.textColor = viewModel.emptyListMessageColor
        emptyListLabel.font = viewModel.emptyListMessageFont
        emptyListLabel.isHidden = true // Initially hidden
        emptyListLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emptyListLabel)

    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            emptyListLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyListLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyListLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

        ])
    }
    
    private func updateView() {
        tableView.reloadData()
        let hasItems = viewModel.numberOfItems > 0
        tableView.isHidden = !hasItems
        emptyListLabel.isHidden = hasItems
    }
}

// MARK: - Table view data source methods
extension CardListView: UITableViewDataSource {
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
extension CardListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.UI.cardCellViewHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCardItem = viewModel.cardItem(at: indexPath.row) else { return }
        viewModel.onCardItemSelected?(selectedCardItem)
    }
}

// MARK: Search bar delegate methods
extension CardListView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchItems(with: searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Dismiss keyboard
    }
}

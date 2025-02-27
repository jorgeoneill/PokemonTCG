//
//  ViewController.swift
//  PokemonTCG
//
//  Created by Jorge O'Neill on 23/02/2025.
//

import UIKit

final class CardListViewController: UIViewController {
    // MARK: - Private properties
    private var cardListViewModel = CardListView.ViewModel()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground  // Adapts to light/dark apperances
        navigationItem.title = String(localized: "navigation_title")
        loadDataTask()
        cardListViewModel.onCardItemSelected = { [weak self] cardListItem in
            self?.displayCardDetail(cardId: cardListItem.id)
        }
        cardListViewModel.onDataUpdated?()
    }
    
    override func loadView() {
        view = CardListView(viewModel: cardListViewModel)
    }
    
    // MARK: - Private methods
    private func loadDataTask() {
        Task {
            do {
                try await cardListViewModel.getCardItems()
            } catch {
                self.displayError(
                    alertTitle: String(localized: "data_unavailable_error_title"),
                    alertMessage: error.localizedDescription,
                    buttonAction: self.loadDataTask
                )
            }
        }
    }

    private func displayCardDetail(cardId: String) {
        Task {
            do {
                let card = try await DataManager.NetworkData.getCard(for: cardId)
                print("Displaying detail for card: \(card.name ?? "Empty name")")
                dump(card)
                
                let cardDetailViewModel = CardDetailView.ViewModel(card: card)
                let cardDetailViewController = CardDetailViewController(viewModel: cardDetailViewModel)
                navigationController?.pushViewController(cardDetailViewController, animated: true)
            } catch {
                print(error)
                self.displayError(
                    alertTitle: String(localized: "data_unavailable_error_title"),
                    alertMessage: error.localizedDescription,
                    buttonAction: self.loadDataTask
                )
            }
        }

    }
    
    private func displayError(
        alertTitle: String,
        alertMessage: String,
        buttonTitle: String? = String(localized: "ok_button"),
        buttonAction: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: buttonTitle,
            style: .default,
            handler: {_ in
            buttonAction?()
            })
        )
        self.present(
            alert,
            animated: true,
            completion: nil
        )
    }
}

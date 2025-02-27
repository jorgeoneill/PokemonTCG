//
//  CardDetailViewController.swift
//  PokemonTCG
//
//  Created by Jorge O'Neill on 26/02/2025.
//

import UIKit

final class CardDetailViewController: UIViewController {
    // MARK: - Private properties
    private let cardDetailViewModel: CardDetailView.ViewModel

    // MARK: - Lifecycle
    init(viewModel: CardDetailView.ViewModel) {
        self.cardDetailViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = CardDetailView(viewModel: cardDetailViewModel)
    }
}

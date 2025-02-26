//
//  ViewController.swift
//  PokemonTCG
//
//  Created by Jorge O'Neill on 23/02/2025.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - Private properties
    private var mainViewModel = MainView.ViewModel()
    private var mainView: MainView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground  // Adapts to light/dark apperances
        setupMainView()
        setupConstraints()
        loadDataTask()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainViewModel.onDataUpdated?()
    }
    
    // MARK: - Private methods
    private func setupMainView() {
        mainView = MainView(viewModel: mainViewModel)
        view.addSubview(mainView)
    }

    private func setupConstraints() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mainView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    
    private func loadDataTask() {
        Task {
            do {
                try await mainViewModel.getCardItems()
            } catch {
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

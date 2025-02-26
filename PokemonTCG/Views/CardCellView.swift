//
//  CardCellView.swift
//  PokemonTCG
//
//  Created by Jorge O'Neill on 24/02/2025.
//

import UIKit

final class CardCellView: UITableViewCell {
    // MARK: - Cell reuse identifier
    static let identifier = Constants.UI.cardCellViewIdentifier

    // MARK: - Private properties
    private var viewModel: ViewModel?
    private let containerView = UIView()
    private let smallCardImageView = UIImageView()
    private let cardNameLabel = UILabel()


    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure Cell
    func configure(with viewModel: ViewModel) {
        self.viewModel = viewModel
        
        // Container view
        containerView.layer.cornerRadius = viewModel.cornerRadius
        containerView.layer.masksToBounds = true
        // Custom background color adapts to light/dark apperances
        containerView.backgroundColor = viewModel.backgroundColor
        
        // Small image view
        self.smallCardImageView.image = nil
        smallCardImageView.contentMode = .scaleAspectFill
        
        // Card name label
        cardNameLabel.text = viewModel.cellTitle
        cardNameLabel.textColor = viewModel.textColor
        cardNameLabel.textAlignment = .center
        cardNameLabel.font = viewModel.font
        cardNameLabel.numberOfLines = 0
        
        // Get image
        Task {
            let image = await viewModel.getCardImage()
            // Check if the displayed cell viewModel is still the same after the image finishes loading, to avoid flickering.
            if self.viewModel === viewModel {
                DispatchQueue.main.async {
                    self.smallCardImageView.image = image
                }
            }
        }
    }

    // MARK: - Private methods
    private func setupSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(smallCardImageView)
        containerView.addSubview(cardNameLabel)

    }

    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        smallCardImageView.translatesAutoresizingMaskIntoConstraints = false
        smallCardImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        smallCardImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        // Slight off-center seems to work best for the intended purpose, which is to display just a glimpse of the card image
        smallCardImageView.centerYAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 30).isActive = true
        
        cardNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        cardNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        cardNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        cardNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
}

//
//  CardDetailView.swift
//  PokemonTCG
//
//  Created by Jorge O'Neill on 26/02/2025.
//

import UIKit

final class CardDetailView: UIView {
    // MARK: - Private properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let cardImageView = UIImageView()
    private let nameLabel = UILabel()
    private let illustratorLabel = UILabel()
    private let rarityLabel = UILabel()
    private let hpLabel = UILabel()
    private let typesLabel = UILabel()
    private let stageLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let retreatCostLabel = UILabel()
    private let regulationMarkLabel = UILabel()
    private let legalitiesLabel = UILabel()
    private let attacksStackView = UIStackView()
    private let weaknessesStackView = UIStackView()
    private let lastUpdatedLabel = UILabel()
    
    private var viewModel: ViewModel


    // MARK: - Lifecycle
    init(viewModel: CardDetailView.ViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupSubviews()
        setupConstraints()
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    private func setupSubviews() {
        backgroundColor = .systemBackground
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        cardImageView.contentMode = .scaleAspectFit
        cardImageView.clipsToBounds = true
        cardImageView.layer.cornerRadius = viewModel.cardCornerRadius
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardImageView)

        [nameLabel, illustratorLabel, rarityLabel, hpLabel, typesLabel, stageLabel, descriptionLabel, retreatCostLabel, regulationMarkLabel, legalitiesLabel, lastUpdatedLabel].forEach { label in
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.font = viewModel.mainFont
            label.textColor = viewModel.textColor
            contentView.addSubview(label)
        }
        
        nameLabel.font = viewModel.titleFont
        nameLabel.textAlignment = .center
        
        hpLabel.font = viewModel.subtitleFont
        hpLabel.textAlignment = .center
        
        lastUpdatedLabel.font = viewModel.footerFont
        lastUpdatedLabel.textAlignment = .center
        
        illustratorLabel.font = viewModel.footerFont
        illustratorLabel.textAlignment = .center

        descriptionLabel.font = viewModel.descriptionFont
        descriptionLabel.textAlignment = .justified

        attacksStackView.axis = .vertical
        attacksStackView.spacing = 8
        attacksStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(attacksStackView)

        weaknessesStackView.axis = .vertical
        weaknessesStackView.spacing = 8
        weaknessesStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(weaknessesStackView)
    }

    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            cardImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            cardImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardImageView.heightAnchor.constraint(equalTo: cardImageView.widthAnchor, multiplier: 1.4),
            
            nameLabel.topAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            hpLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            hpLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: hpLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                        
            attacksStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            attacksStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            attacksStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            weaknessesStackView.topAnchor.constraint(equalTo: attacksStackView.bottomAnchor, constant: 16),
            weaknessesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            weaknessesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            retreatCostLabel.topAnchor.constraint(equalTo: weaknessesStackView.bottomAnchor, constant: 16),
            retreatCostLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            //retreatCostLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            regulationMarkLabel.topAnchor.constraint(equalTo: retreatCostLabel.bottomAnchor, constant: 8),
            regulationMarkLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            //regulationMarkLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            legalitiesLabel.topAnchor.constraint(equalTo: regulationMarkLabel.bottomAnchor, constant: 8),
            legalitiesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            //legalitiesLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                                    
            rarityLabel.topAnchor.constraint(equalTo: legalitiesLabel.bottomAnchor, constant: 8),
            rarityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            //rarityLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            typesLabel.topAnchor.constraint(equalTo: rarityLabel.bottomAnchor, constant: 8),
            typesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            //typesLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            stageLabel.topAnchor.constraint(equalTo: typesLabel.bottomAnchor, constant: 8),
            stageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            //stageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            lastUpdatedLabel.topAnchor.constraint(equalTo: stageLabel.bottomAnchor, constant: 8),
            lastUpdatedLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            illustratorLabel.topAnchor.constraint(equalTo: lastUpdatedLabel.bottomAnchor, constant: 8),
            illustratorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            illustratorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)


        ])
    }

    // MARK: - Configure View
    private func configure() {
        nameLabel.text = viewModel.cardName
        illustratorLabel.text = viewModel.illustrator
        rarityLabel.text = viewModel.rarity
        hpLabel.text = viewModel.hp
        typesLabel.text = viewModel.types
        stageLabel.text = viewModel.stage
        descriptionLabel.text = viewModel.description
        retreatCostLabel.text = viewModel.retreatCost
        regulationMarkLabel.text = viewModel.regulationMark
        legalitiesLabel.text = viewModel.legalities
        lastUpdatedLabel.text = viewModel.lastUpdated
        viewModel.attacks.forEach { attack in
            let label = UILabel()
            label.numberOfLines = 0
            label.text = "⚔️ \(attack.name): \(attack.damage) (\(attack.cost))"
            label.font = viewModel.mainFont
            label.textColor = viewModel.textColor
            attacksStackView.addArrangedSubview(label)
        }

        viewModel.weaknesses.forEach { weakness in
            let label = UILabel()
            label.numberOfLines = 0
            label.text = "💀 \(weakness.type) (\(weakness.value))"
            label.font = viewModel.mainFont
            label.textColor = viewModel.textColor
            weaknessesStackView.addArrangedSubview(label)
        }
                
        Task {
            guard
                let url = viewModel.imageURL,
                let image = try? await DataManager.NetworkData.getImage(from: url)
            else {
                // Set set cardImageView height to zero if no image is availavle
                cardImageView.heightAnchor.constraint(equalToConstant: 0).isActive = true
                return
            }

            cardImageView.image = image
        }
    }
}

//
//  PersonCellHolder.swift
//  CollectionViewEx
//
//  Created by 김종권 on 2021/08/29.
//

import UIKit

extension PersonCell {
    func setupView() {

        clipsToBounds = true
        autoresizesSubviews = true
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        layer.cornerRadius = 20.0

        bgView.frame = self.bounds
        bgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bgView.backgroundColor = .systemGray
        backgroundView = bgView

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 12.0
        imageView.layer.borderWidth = 1.0
        imageView.layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        imageView.clipsToBounds = true
        addSubview(imageView)

        let labelStackView = UIStackView()
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.axis = .vertical
        labelStackView.spacing = 5.0
        addSubview(labelStackView)

        updateIndicator.frame = CGRect(x: 0, y: 0, width: 10.0, height: 10.0)
        updateIndicator.translatesAutoresizingMaskIntoConstraints = false
        updateIndicator.backgroundColor = .cyan
        updateIndicator.layer.cornerRadius = 5.0
        updateIndicator.isHidden = true
        addSubview(updateIndicator)

        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.addArrangedSubview(nameLabel)

        noteLabel.textColor = .white.withAlphaComponent(0.3)
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.addArrangedSubview(noteLabel)

        setupLayout(with: labelStackView)
    }

    func setupLayout(with labelStackView: UIStackView) {
        let constraints = [
            imageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 54.0),
            imageView.heightAnchor.constraint(equalToConstant: 54.0),

            labelStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8.0),
            labelStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            labelStackView.firstBaselineAnchor.constraint(equalTo: topAnchor, constant: 32.0),

            updateIndicator.centerYAnchor.constraint(equalTo: noteLabel.centerYAnchor),
            updateIndicator.centerXAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -16.0),
            updateIndicator.widthAnchor.constraint(equalToConstant: 10.0),
            updateIndicator.heightAnchor.constraint(equalToConstant: 10.0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

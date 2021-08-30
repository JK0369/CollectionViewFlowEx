//
//  ComplexCellHolder.swift
//  CollectionViewEx
//
//  Created by 김종권 on 2021/08/31.
//

import UIKit

extension ComplexCell {
    func setupView() {

        label.textColor = .black
        addSubview(label)

        setupLayout()
    }

    func setupLayout() {
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

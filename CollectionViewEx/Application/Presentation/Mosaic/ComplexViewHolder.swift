//
//  ComplexViewHolder.swift
//  CollectionViewEx
//
//  Created by 김종권 on 2021/08/31.
//

import UIKit

extension ComplexViewConroller {
    func setupView() {
        view.backgroundColor = .systemBackground

        collectionView.backgroundColor = .systemGray.withAlphaComponent(0.3)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.alwaysBounceVertical = true
        collectionView.indicatorStyle = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ComplexCell.self, forCellWithReuseIdentifier: ComplexCell.className)
        view.addSubview(collectionView)

        navigationItem.titleView = avatarView

        setupLayout()
    }

    func setupLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

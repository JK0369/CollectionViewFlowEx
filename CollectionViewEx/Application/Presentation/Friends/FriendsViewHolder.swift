//
//  FriendsViewHolder.swift
//  CollectionViewEx
//
//  Created by 김종권 on 2021/08/29.
//

import UIKit

extension FriendsViewController {
    func setupView() {
        collectionView.backgroundColor = .systemGray.withAlphaComponent(0.3)
        collectionView.register(PersonCell.self, forCellWithReuseIdentifier: PersonCell.className)
        collectionView.delegate = self
        collectionView.dataSource = self

        insertButton.setTitle("삽입", for: .normal)
        insertButton.addTarget(self, action: #selector(didTapInsertButton(_:)), for: .touchUpInside)

        deleteButton.setTitle("삭제", for: .normal)
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton(_:)), for: .touchUpInside)

        multiButton.setTitle("멀티", for: .normal)
        multiButton.addTarget(self, action: #selector(didTapUpdateButton(_:)), for: .touchUpInside)

        buttonStackView.spacing = 5.0
        [insertButton, deleteButton, multiButton].forEach { buttonStackView.addArrangedSubview($0) }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonStackView)

        // navigationBar
        title = "Friends"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        // barButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: AvartarView())

        // collectionView
        view.addSubview(collectionView)
        collectionView.alwaysBounceVertical = true
        collectionView.indicatorStyle = .white

        setupLayout()
    }

    func setupLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

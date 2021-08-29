//
//  BaseCollectionViewCell.swift
//  CollectionViewEx
//
//  Created by 김종권 on 2021/08/27.
//

import UIKit

class BaseCollectionViewCell<T>: UICollectionViewCell {

    var model: T? {
        didSet { bind(model: model) }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {}
    func bind(model: T?) {}
}

//
//  ComplexCell.swift
//  CollectionViewEx
//
//  Created by 김종권 on 2021/08/31.
//

import UIKit

class ComplexCell: BaseCollectionViewCell<Complex> {

    let label = UILabel()

    override func configure() {
        super.configure()

        setupView()
    }

    override func bind(model: Complex?) {
        super.bind(model: model)

        label.text = model?.title
        backgroundColor = model?.color
    }
}

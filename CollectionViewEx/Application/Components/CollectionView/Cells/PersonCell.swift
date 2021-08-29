//
//  PersonCell.swift
//  CollectionViewEx
//
//  Created by 김종권 on 2021/08/27.
//

import UIKit

class PersonCell: BaseCollectionViewCell<Person> {

    let bgView = UIView()
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let noteLabel = UILabel()
    let updateIndicator = UIView()
    
    override func configure() {
        super.configure()

        setupView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        updateIndicator.isHidden = true
    }

    override func bind(model: Person?) {
        super.bind(model: model)

        guard let model = model else { return }

        nameLabel.text = model.name

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        noteLabel.text = formatter.string(from: model.lastUpdate)

        if let imageName = model.imageName {
            imageView.image = UIImage(named: imageName)
        }
        if let updated = model.isUpdate {
            updateIndicator.isHidden = !updated
            if updated {
                noteLabel.text = "Updated now"
            }
        }
    }
}

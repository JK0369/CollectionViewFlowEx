//
//  ComplexViewController.swift
//  CollectionViewEx
//
//  Created by 김종권 on 2021/08/31.
//

import UIKit

class ComplexViewConroller: UIViewController {
    let avatarView = AvartarView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: MosaicLayout())
    var dataSource: [Complex] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if collectionView.numberOfItems(inSection: 0) > 0 {
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
    }

    private func setupDataSource() {
        (0...150).forEach {
            let color = UIColor(red: CGFloat(drand48()),
                                green: CGFloat(drand48()),
                                blue: CGFloat(drand48()),
                                alpha: CGFloat(Float(arc4random()) / Float(UINT32_MAX)))
            dataSource.append(Complex(color: color, title: String($0)))
        }
    }
}

extension ComplexViewConroller: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComplexCell.className, for: indexPath) as! ComplexCell
        cell.model = dataSource[indexPath.item]
        return cell
    }
}

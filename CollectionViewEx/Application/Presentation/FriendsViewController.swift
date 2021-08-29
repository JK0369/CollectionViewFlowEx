
//  FriendsViewController.swift
//  CollectionViewEx
//
//  Created by 김종권 on 2021/08/27.
//

import UIKit

class FriendsViewController: UIViewController {

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: ColumnFlowLayout())
    let insertButton = UIButton()
    let deleteButton = UIButton()
    let multiButton = UIButton()
    let buttonStackView = UIStackView()

    private var peopleDataSource = Mock.samplePerson()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    @objc func didTapInsertButton(_ sender: Any) {
        let sampleUpdates = [
            CollectionViewUpdateState<Person>.insert(Person(name: "samir", month: 6, day: 2, year: 2018), (0..<collectionView.numberOfItems(inSection: 0)).randomElement() ?? 0),
        ]
        performUpdate(sampleUpdates: sampleUpdates)
    }

    @objc func didTapDeleteButton(_ sender: Any) {
        let sampleUpdates = [
            CollectionViewUpdateState<Person>.delete(peopleDataSource.count - 1),
        ]
        performUpdate(sampleUpdates: sampleUpdates)
    }

    @objc func didTapUpdateButton(_ sender: Any) {
        let sampleUpdates = [
            CollectionViewUpdateState<Person>.move(0, 1),
            CollectionViewUpdateState<Person>.move(1, 2),
            CollectionViewUpdateState<Person>.move(2, 3),
            CollectionViewUpdateState<Person>.reload(3) // 변경된 데이터 뷰에 갱신
        ]
        performUpdate(sampleUpdates: sampleUpdates)
    }

    private func performUpdate(sampleUpdates: [CollectionViewUpdateState<Person>]) {

        collectionView.performBatchUpdates {
            var deletes = [Int]()
            var inserts = [(person:Person, index:Int)]()

            sampleUpdates.forEach {
                switch $0 {
                case let .delete(index):
                    collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
                    deletes.append(index)

                case let .insert(person, index):
                    collectionView.insertItems(at: [IndexPath(item: index, section: 0)])
                    inserts.append((person, index))

                case let .move(fromIndex, toIndex):
                    collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                            to: IndexPath(item: toIndex, section: 0))
                    deletes.append(fromIndex)
                    inserts.append((peopleDataSource[fromIndex], toIndex))

                default: break
                }
            }

            // 삭제를 내림차순 배열에서 진행: 삭제가 진행되면 index값이 줄어들기 때문
            deletes.sorted().reversed()
                .forEach { peopleDataSource.remove(at: $0) }

            // 삽입을 오름차순 배열에서 진행
            inserts.sorted(by: {  return $0.index <= $1.index })
                .forEach { peopleDataSource.insert($0.person, at: $0.index) }

        } completion: { _ in
            print("finish update !!!")
        }

    }
}

extension FriendsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        peopleDataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCell.className, for: indexPath) as? PersonCell else {
            fatalError(#function)
        }

        cell.model = peopleDataSource[indexPath.item]
        return cell
    }
}

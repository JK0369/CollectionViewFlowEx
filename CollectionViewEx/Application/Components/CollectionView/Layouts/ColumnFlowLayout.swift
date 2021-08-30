//
//  ColumnFlowLayout.swift
//  CollectionViewEx
//
//  Created by 김종권 on 2021/08/27.
//

import UIKit

class ColumnFlowLayout: UICollectionViewFlowLayout {

    // cell 너비의 최소값만 알고 있으면 뷰에 알아서 grid형태이든, tableView형태이든 알아서 뿌려지는 형태
    private let minColumnWidth: CGFloat = UIScreen.main.bounds.width / 3
    private let cellHeight: CGFloat = 70.0

    // 변경사항 (삭제, 삽입) 기록 > performBatchUpdates(_:completion:)에서 일괄 변경을 위해 사용
    private var deletingIndexPaths = [IndexPath]()
    private var insertingIndexPaths = [IndexPath]()

    // cell의 레이아웃 업데이트 전에 호출하여 레이아웃 적용
    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        let maxNumColumns = Int(availableWidth / minColumnWidth)
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)

        itemSize = CGSize(width: cellWidth, height: cellHeight)
        sectionInset = UIEdgeInsets(top: minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
        sectionInsetReference = .fromSafeArea
    }

    // MARK: Updates (삭제, 삽입)

    // item이 변경(삭제, 삽입)되기 직전에 호출
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare()

        for update in updateItems {
            switch update.updateAction {
            case .delete:
                /// indexPath에 해당하는 item이 삭제되기 전에 deletingIndexPaths에 삽입
                guard let indexPath = update.indexPathBeforeUpdate else { return }
                deletingIndexPaths.append(indexPath)
            case .insert:
                /// indexPath에 해당하는 item이 추가된 다음 insertingIndexPaths에 삽입
                guard let indexPath = update.indexPathAfterUpdate else { return }
                insertingIndexPaths.append(indexPath)
            default:
                break
            }
        }
    }

    // MARK: attributes (삭제, 삽입)

    // 삭제 시 적용 애니메이션
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath) else { return nil }

        if deletingIndexPaths.contains(itemIndexPath) {
            attributes.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            attributes.alpha = 0.0
            attributes.zIndex = 0
        }

        /// nil반환 시 애니메이션의 start point와 end point 모두 동일한 attributes 사용
        return attributes
    }

    // 삽입 시 적용 애니메이션
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) else { return nil }

        if insertingIndexPaths.contains(itemIndexPath) {
            attributes.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            attributes.alpha = 0.0
            attributes.zIndex = 0
        }

        /// nil반환 시 애니메이션의 start point와 end point 모두 동일한 attributes 사용
        return attributes
    }

    // performBatchUpdates(:completion)호출에서 compeltion이 시작되기 바로 직전에 호출
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()

        insertingIndexPaths.removeAll()
        deletingIndexPaths.removeAll()
    }
}

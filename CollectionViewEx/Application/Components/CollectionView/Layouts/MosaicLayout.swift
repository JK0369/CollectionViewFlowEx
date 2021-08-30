//
//  MosaicLayout.swift
//  CollectionViewEx
//
//  Created by 김종권 on 2021/08/31.
//

import UIKit

enum MosaicSegmentStyle {
    /// horizontal 1조각
    case fullWidth
    /// horizontal 각각 0.5씩 나누어진 2조각
    case fiftyFifty
    /// vertical은 2/3로 나누어진 2조각, horizontal은 0.5로 나누어진 1조각
    case twoThirdsOneThird
    /// vertical은 3/1로 나누어진 2조각, horizontal은 0.5로 나누어진 1조각
    case oneThirdTwoThirds
}

class MosaicLayout: UICollectionViewLayout {

    /// 계속 누적하여, collectionViewContentSize값을 구해야할 때 사용되는 프로퍼티
    var contentBounds: CGRect = .zero
    /// prepare에서 cachedAttributes 값들을 계산 후, 스크롤 할때마다 layout 값이 필요한데, 이 값을 사용
    var cachedAttributes = [UICollectionViewLayoutAttributes]()

    /// 컬렉션에서 항목이 추가, 제거, 방향이 바뀔때 호출되는 메소드
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }

        // 초기화
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
        let count = collectionView.numberOfItems(inSection: 0)
        var currentIndex = 0
        var segment: MosaicSegmentStyle = .fullWidth
        /// lastFrame: 다음 cell의 Y좌표값을 알기 위해서 직전 cell의 maxY값을 기록하기 위한 프로퍼티
        var lastFrame: CGRect = .zero
        let collectionViewWidth = collectionView.bounds.size.width

        // layout 계산
        while currentIndex < count {
            /// segmentFrame: cell들을 slice하기 전의 전체 크기
            let segmentFrame = CGRect(x: 0, y: lastFrame.maxY + 1.0, width: collectionViewWidth, height: 200.0)

            /// segmentFrame값이 slice되어 cell각각의 Rect값이 기록될 프로퍼티
            var segmentRects: [CGRect] = []

            switch segment {
            case .fullWidth:
                segmentRects = [segmentFrame]
            case .fiftyFifty:
                let horizontalSlices = segmentFrame.dividedIntegral(fraction: 0.5, from: .minXEdge)
                segmentRects = [horizontalSlices.first, horizontalSlices.second]
            case .twoThirdsOneThird:
                let horizontalSlices = segmentFrame.dividedIntegral(fraction: 2.0 / 3.0, from: .minXEdge)
                let verticalSlices = horizontalSlices.second.dividedIntegral(fraction: 0.5, from: .minYEdge)
                segmentRects = [horizontalSlices.first, verticalSlices.first, verticalSlices.second]
            case .oneThirdTwoThirds:
                let horizontalSlices = segmentFrame.dividedIntegral(fraction: 1.0 / 3.0, from: .minXEdge)
                let verticalSlices = horizontalSlices.first.dividedIntegral(fraction: 0.5, from: .minYEdge)
                segmentRects = [verticalSlices.first, verticalSlices.second, horizontalSlices.second]
            }

            // 계산된 Rect 조각들을 가지고 cacheAttributes와 contentBounds에 추가
            for rect in segmentRects {
                let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: currentIndex, section: 0))
                attributes.frame = rect

                cachedAttributes.append(attributes)
                contentBounds = contentBounds.union(lastFrame)

                currentIndex += 1
                lastFrame = rect
            }

            // 다음 레이아웃 변경
            switch count - currentIndex {
            case 1:
                segment = .fullWidth
            case 2:
                segment = .fiftyFifty
            default:
                switch segment {
                case .fullWidth:
                    segment = .fiftyFifty
                case .fiftyFifty:
                    segment = .twoThirdsOneThird
                case .twoThirdsOneThird:
                    segment = .oneThirdTwoThirds
                case .oneThirdTwoThirds:
                    segment = .fiftyFifty
                }
            }
        }
    }

    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }

    // layout객체에 업데이트가 필요한지 여부 반환: prepare 메소드를 호출할지 결정 - 매번 true 반환 필요
    // 단, newBounds가 기존 collectionView의 bounds사이즈와 동일하다면 호출이 필요 없는 상태
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }

    // 현재 보여지는 화면 rect안에 속하는 cell들의 layout을 찾아서 리턴 > 찾을때 binary search 사용
    // 해당 메소드는 scrolling 될때마다 호출 > O(n)으로 접근시 큰 부하 > attributes는 이미 정렬되어 있다는 것을 활용
    // IndexPath로 인수가 들어오면 random access로 O(1)로 효율적으로 탐색할수 있지만, rect로 들어온 경우는 O(n)이 되면 비효율적이므로 binSearch 사용
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var attributesArray = [UICollectionViewLayoutAttributes]()

        // rect에 해당하는 cell의 index 탐색
        guard let lastIndex = cachedAttributes.indices.last,
              let firstMatchIndex = binSearch(rect, start: 0, end: lastIndex) else { return attributesArray }

        for attributes in cachedAttributes[..<firstMatchIndex].reversed() {
            guard attributes.frame.maxY >= rect.minY else { break }
            attributesArray.append(attributes)
        }

        for attributes in cachedAttributes[firstMatchIndex...] {
            guard attributes.frame.minY <= rect.maxY else { break }
            attributesArray.append(attributes)
        }

        return attributesArray
    }

    /// 인수로 들어온 rect에 해당하는 `UICollectionViewLayoutAttributes`의 index값 탐색
    func binSearch(_ rect: CGRect, start: Int, end: Int) -> Int? {
        if end < start { return nil }

        let mid = (start + end) / 2
        let attr = cachedAttributes[mid]

        /// intersects: 교집합
        if attr.frame.intersects(rect) {
            return mid
        } else {
            if attr.frame.maxY < rect.minY {
                return binSearch(rect, start: (mid + 1), end: end)
            } else {
                return binSearch(rect, start: start, end: (mid - 1))
            }
        }
    }

}

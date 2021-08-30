//
//  CGRect.swift
//  CollectionViewEx
//
//  Created by 김종권 on 2021/08/31.
//

import UIKit

extension CGRect {

    /// 사각형을 from을 기준으로 fraction비율로 두개로 slice하는 메소드
    func dividedIntegral(fraction: CGFloat, from fromEdge: CGRectEdge) -> (first: CGRect, second: CGRect) {
        let dimension: CGFloat

        switch fromEdge {
        case .minXEdge, .maxXEdge:
            dimension = self.size.width
        case .minYEdge, .maxYEdge:
            dimension = self.size.height
        }

        // slice된 최종 길이
        let distance = (dimension * fraction).rounded(.up)

        // 원래의 사각형을 나누어 두 개의 사각형으로 나누는 작업: CGRect타입의 (slice, remaider) 리턴
        var slices = self.divided(atDistance: distance, from: fromEdge)

        // cell 사이의 간격을 주기 위한 처리
        switch fromEdge {
        case .minXEdge, .maxXEdge:
            // +1만큼 x좌표를 더한 다음, 늘어난 만큼 width -1
            slices.remainder.origin.x += 1
            slices.remainder.size.width -= 1
        case .minYEdge, .maxYEdge:
            slices.remainder.origin.y += 1
            slices.remainder.size.height -= 1
        }

        return (first: slices.slice, second: slices.remainder)
    }
}

//
//  CollectionViewUpdateState.swift
//  CollectionViewEx
//
//  Created by 김종권 on 2021/08/29.
//

import Foundation

enum CollectionViewUpdateState<T> {
    case delete(Int)
    case insert(T, Int)
    case move(Int, Int)
    case reload(Int)
}

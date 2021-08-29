//
//  NSObject.swift
//  CollectionViewEx
//
//  Created by 김종권 on 2021/08/27.
//

import Foundation

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
}

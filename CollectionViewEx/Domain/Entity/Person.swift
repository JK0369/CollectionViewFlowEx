//
//  Person.swift
//  CollectionViewEx
//
//  Created by 김종권 on 2021/08/27.
//

import Foundation

struct Person: CustomStringConvertible {
    var name: String?
    var imageName: String?
    var lastUpdate = Date()

    init(name: String, month: Int, day: Int, year: Int) {
        self.name = name
        self.imageName = name.lowercased()

        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year
        if let date = Calendar.current.date(from: components) {
            lastUpdate = date
        }
    }

    var isUpdate: Bool? {
        didSet { lastUpdate = Date() }
    }

    var description: String {
        if let name = self.name {
            return "<\(type(of: self)): name = \(name)"
        } else {
            return "<\(type(of: self))"
        }
    }
}

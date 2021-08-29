//
//  Mock.swift
//  CollectionViewEx
//
//  Created by 김종권 on 2021/08/27.
//

import Foundation

struct Mock {
    static func samplePerson() -> [Person] {
        return [
            Person(name: "mohammed", month: 6, day: 3, year: 2018),
            Person(name: "samir", month: 6, day: 2, year: 2018),
            Person(name: "steve", month: 5, day: 21, year: 2018),
            Person(name: "Priyanka", month: 5, day: 20, year: 2018)
        ]
    }
}

//
//  Section.swift
//  DiffDataSource
//
//  Created by Abduaziz on 2/7/23.
//

import Foundation

enum Kind {
    case grid, page, more
}

// Section
struct Section: Hashable {
    let header: String
    let footer: String
    let kind: Kind
    private let id = UUID.init()
}

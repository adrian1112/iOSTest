//
//  ItemModel.swift
//  iosTest
//
//  Created by Adrian Aguilar on 15/4/25.
//

import Foundation

struct PaginationResponse: Codable {
    let totalCount: Int
    let next: String?
    let previous: String?
    let results: [Item]
    
    private enum CodingKeys: String, CodingKey {
        case totalCount = "count"
        case next
        case previous
        case results
    }
}

struct Item: Codable {
    let name: String
    let url: String
}

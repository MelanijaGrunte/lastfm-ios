//
//  PagingMeta.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 09/05/2021.
//

import Foundation

public class PagingMeta: Decodable {
    public let page: Int
    public let perPage: Int
    public let total: Int
    public let totalPages: Int
    
    var lastPageReached: Bool {
        page == totalPages
    }
    
    private enum CodingKeys: String, CodingKey {
        case page
        case perPage
        case total
        case totalPages
    }
    
    public init(page: Int, perPage: Int, total: Int, totalPages: Int) {
        self.page = page
        self.perPage = perPage
        self.total = total
        self.totalPages = totalPages
    }
    
    public required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let pageString = try container.decode(String.self, forKey: .page)
            page = Int(pageString) ?? 1
            let perPageString = try container.decode(String.self, forKey: .perPage)
            perPage = Int(perPageString) ?? 50
            let totalString = try container.decode(String.self, forKey: .total)
            total = Int(totalString) ?? 0
            let totalPagesString = try container.decode(String.self, forKey: .totalPages)
            totalPages = Int(totalPagesString) ?? 0
        } catch let error {
            print(error.localizedDescription)
            throw error
        }
    }
}

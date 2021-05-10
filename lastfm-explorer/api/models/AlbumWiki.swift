//
//  AlbumWiki.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 09/05/2021.
//

import Foundation

public class AlbumWiki: Decodable {
    public let published: String
    public let summary: String
    public let content: String
    
    private enum CodingKeys: String, CodingKey {
        case published
        case summary
        case content
    }
    
    public required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            published = try container.decode(String.self, forKey: .published)
            summary = try container.decode(String.self, forKey: .summary)
            content = try container.decode(String.self, forKey: .content)
        } catch let error {
            print(error.localizedDescription)
            throw error
        }
    }
}

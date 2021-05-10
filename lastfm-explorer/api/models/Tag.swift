//
//  Tag.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 09/05/2021.
//

import Foundation

public class Tag: Decodable {
    public let name: String
    public let url: String
        
    private enum CodingKeys: String, CodingKey {
        case name
        case url
    }
        
    public required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
                
            name = try container.decode(String.self, forKey: .name)
            url = try container.decode(String.self, forKey: .url)
        } catch let error {
            print(error.localizedDescription)
            throw error
        }
    }
}

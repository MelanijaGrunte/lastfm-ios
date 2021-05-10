//
//  Artist.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 08/05/2021.
//

import Foundation

public class Artist: Decodable {
    public let mbid: String?
    public let name: String
    
    private enum ArtistCodingKeys: String, CodingKey {
        case mbid
        case name
    }
    
    public init(mbid: String?, name: String) {
        self.mbid = mbid
        self.name = name
    }
    
    public required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: ArtistCodingKeys.self)
            
            mbid = try container.decodeIfPresent(String.self, forKey: .mbid)
            name = try container.decode(String.self, forKey: .name)
        } catch let error {
            print(error.localizedDescription)
            throw error
        }
    }
}

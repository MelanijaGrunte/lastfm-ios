//
//  TopAlbum.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 09/05/2021.
//

import Foundation


public class TopAlbums: Decodable {
    public let albums: [Album]
    public let pagingMeta: PagingMeta
    
    private enum CodingKeys: String, CodingKey {
        case topAlbum = "topalbums"
        case albums = "album"
        
        case attributes = "@attr"
    }
    
    public init(albums: [Album], pagingMeta: PagingMeta) {
        self.albums = albums
        self.pagingMeta = pagingMeta
    }
    
    public required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .topAlbum)
            
            albums = try nestedContainer.decode([Album].self, forKey: .albums)
            pagingMeta = try nestedContainer.decode(PagingMeta.self, forKey: .attributes)
        } catch let error {
            print(error.localizedDescription)
            throw error
        }
    }
}

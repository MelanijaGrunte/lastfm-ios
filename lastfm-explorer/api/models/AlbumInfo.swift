//
//  AlbumInfo.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 09/05/2021.
//

import Foundation

public class AlbumInfo: Decodable {
    let album: ExtendedAlbum
    
    private enum CodingKeys: String, CodingKey {
        case album
    }
    
    public required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            album = try container.decode(ExtendedAlbum.self, forKey: .album)
        } catch let error {
            print(error.localizedDescription)
            throw error
        }
    }
}

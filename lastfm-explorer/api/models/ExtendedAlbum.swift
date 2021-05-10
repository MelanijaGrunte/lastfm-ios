//
//  ExtendedAlbum.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 09/05/2021.
//

import Foundation

public class ExtendedAlbum: Album {
    public let listeners: String
    public let topTags: [Tag]
    public let tracks: [Track]
    public let wiki: AlbumWiki?

    private enum CodingKeys: String, CodingKey {
        case listeners
        case tag
        case track
        case wiki
        
        case tags
        case tracks
    }
    
    public required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let tagsContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .tags)
            let tracksContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .tracks)
            
            listeners = try container.decode(String.self, forKey: .listeners)
            topTags = try tagsContainer.decode([Tag].self, forKey: .tag)
            tracks = try tracksContainer.decode([Track].self, forKey: .track)
            wiki = try container.decodeIfPresent(AlbumWiki.self, forKey: .wiki)
            
            try super.init(from: decoder)
        } catch let error {
            print(error.localizedDescription)
            throw error
        }
    }
}

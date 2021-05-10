//
//  Album.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 07/05/2021.
//

import Foundation

public class Album: Decodable {
    public let mbid: String
    public var artist: Artist? = nil
    public var rank: Int? = nil
    public let images: [AlbumImage]
    public var playCount: Int? = nil
    public let title: String
        
    private enum AlbumCodingKeys: String, CodingKey {
        case mbid
        case artist
        case rank
        case images = "image"
        case playCount = "playcount"
        case title = "name"
        
        case attributes = "@attr"
    }
    
    public init(mbid: String, artist: Artist?, rank: Int?, images: [AlbumImage], playCount: Int?, title: String) {
        self.mbid = mbid
        self.artist = artist
        self.rank = rank
        self.images = images
        self.playCount = playCount
        self.title = title
    }
    
    public required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: AlbumCodingKeys.self)
            var attrContainer = container

            if container.contains(.attributes) {
                attrContainer = try container.nestedContainer(keyedBy: AlbumCodingKeys.self, forKey: .attributes)
            }
            
            mbid = try container.decode(String.self, forKey: .mbid)
            title = (try? container.decodeIfPresent(String.self, forKey: .title)) ?? ""

            if let fullArtist = try? container.decodeIfPresent(Artist.self, forKey: .artist) {
                artist = fullArtist
            } else if let artistName = try? container.decodeIfPresent(String.self, forKey: .artist) {
                artist = Artist(mbid: "", name: artistName)
            }
            
            if let rankString = try? attrContainer.decodeIfPresent(String.self, forKey: .rank) {
                rank = Int(rankString)
            }
            if let playCountString = try? container.decode(String.self, forKey: .playCount) {
                playCount = Int(playCountString)
            }
            
            images = (try? container.decodeIfPresent([AlbumImage].self, forKey: .images)) ?? []
        } catch let error {
            print(error.localizedDescription)
            throw error
        }
    }
}

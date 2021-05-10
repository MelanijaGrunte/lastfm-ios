//
//  Track.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 09/05/2021.
//

import Foundation

public class Track: Decodable {
    public let name: String
    public let duration: String
    public let url: String
    public let artist: Artist
    
    public var formattedDuration: String? {
        guard let totalSeconds = Int(duration) else { return nil }
        let minutes = totalSeconds / 60
        let remainingSeconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case duration
        case url
        case artist
    }
    
    public required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            name = try container.decode(String.self, forKey: .name)
            duration = try container.decode(String.self, forKey: .duration)
            url = try container.decode(String.self, forKey: .url)
            artist = try container.decode(Artist.self, forKey: .artist)
        } catch let error {
            print(error.localizedDescription)
            throw error
        }
    }
}

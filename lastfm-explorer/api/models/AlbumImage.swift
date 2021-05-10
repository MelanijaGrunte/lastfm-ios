//
//  AlbumImage.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 08/05/2021.
//

import Foundation

public enum ImageSize: String, Decodable {
    case small
    case medium
    case large
    case extralarge
    case mega
    case other
}

public class AlbumImage: Decodable {
    public let size: ImageSize
    public let url: String
    
    private enum AlbumImageCodingKeys: String, CodingKey {
        case size
        case url = "#text"
    }
    
    public required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: AlbumImageCodingKeys.self)
            
            size = (try? container.decodeIfPresent(ImageSize.self, forKey: .size)) ?? .other
            url = (try? container.decodeIfPresent(String.self, forKey: .url)) ?? ""
        } catch let error {
            print(error.localizedDescription)
            throw error
        }
    }
}

//
//  ApiError.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 08/05/2021.
//

import Foundation

public class ApiError: Decodable, Error {
    public let error: Int
    public let message: String
    
    private enum CodingKeys: String, CodingKey {
        case error
        case message
    }

    public init(errorCode: Int, message: String) {
        self.error = errorCode
        self.message = message
    }
        
    public required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            error = try container.decode(Int.self, forKey: .error)
            message = try container.decode(String.self, forKey: .message)
        } catch let error {
            throw error
        }
    }
    
    static public let parsingError = ApiError(errorCode: -1, message: "Parsing error")
}

extension ApiError: LocalizedError {
    public var errorDescription: String? {
        message
    }
}

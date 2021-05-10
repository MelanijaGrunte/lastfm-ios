//
//  Api.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 07/05/2021.
//

import Foundation
import RxAlamofire
import RxSwift

public class Api {
    private let domain = "https://ws.audioscrobbler.com"
    private let apiKey = "94c2a5278c3f82241d33975b7d03238d"
    
    public init() {}
    
    public static func loadImage(url: URL) -> Single<UIImage?> {
        RxAlamofire
            .request(.get, url)
            .validate()
            .responseData()
            .map { (response) -> UIImage? in
                let (_, data) = response
                return UIImage(data: data)
            }
            .asSingle()
    }
    
    public func loadTopAlbums(username: String, period: Period, page: Int?) -> Single<TopAlbums> {
        var urlComponents = URLComponents(string: "\(domain)/2.0/")!
        urlComponents.queryItems = [
            URLQueryItem(name: "method", value: "user.gettopalbums"),
            URLQueryItem(name: "user", value: username),
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "period", value: period.rawValue),
            URLQueryItem(name: "format", value: "json"),
            page.map { URLQueryItem(name: "page", value: $0.description) }
        ].compactMap { $0 }
        
        return RxAlamofire
            .request(.get, urlComponents)
            .validate()
            .responseData()
            .flatMap { (response) -> Observable<TopAlbums> in
                let (_, data) = response
                
                guard let topAlbums = try? JSONDecoder().decode(TopAlbums.self, from: data) else {
                    let error = try? JSONDecoder().decode(ApiError.self, from: data)
                    return Observable.error(error ?? ApiError.parsingError)
                }

                return Observable.just(topAlbums)
            }
            .asSingle()
    }
    
    public func getAlbumDetails(id: String, username: String) -> Single<ExtendedAlbum> {
        var urlComponents = URLComponents(string: "\(domain)/2.0/")!
        urlComponents.queryItems = [
            URLQueryItem(name: "method", value: "album.getinfo"),
            URLQueryItem(name: "mbid", value: id),
            URLQueryItem(name: "user", value: username),
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "format", value: "json")
         ]
        
        return RxAlamofire
            .request(.get, urlComponents)
            .validate()
            .responseData()
            .flatMap { (response) -> Observable<ExtendedAlbum> in
                let (_, data) = response
                
                guard let albumInfo = try? JSONDecoder().decode(AlbumInfo.self, from: data) else {
                    let error = try? JSONDecoder().decode(ApiError.self, from: data)
                    return Observable.error(error ?? ApiError.parsingError)
                }
                
                return Observable.just(albumInfo.album)
            }
            .asSingle()
    }
}

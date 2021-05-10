//
//  AlbumRepository.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 07/05/2021.
//

import RxSwift

public protocol AutoMockable { }

public protocol AlbumRepository: AutoMockable {
    func getTopAlbums(username: String, period: Period, page: Int?) -> Single<TopAlbums>
    func getAlbumDetails(id: String, username: String) -> Single<ExtendedAlbum>
}

public class ConcreteAlbumRepository: AlbumRepository {
    
    private let api: Api
        
    init(api: Api) {
        self.api = api
    }

    public func getTopAlbums(username: String, period: Period, page: Int?) -> Single<TopAlbums> {
        self.api.loadTopAlbums(username: username, period: period, page: page)
    }
    
    public func getAlbumDetails(id: String, username: String) -> Single<ExtendedAlbum> {
        self.api.getAlbumDetails(id: id, username: username)
    }
}

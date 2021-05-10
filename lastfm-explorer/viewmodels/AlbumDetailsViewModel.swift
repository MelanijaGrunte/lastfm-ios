//
//  AlbumDetailsViewModel.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 07/05/2021.
//

import RxSwift

public protocol AlbumDetailsViewModelInputs {
    func didTapOnHeart(track: Track)
}

public protocol AlbumDetailsViewModelOutputs {
    var albumDetails: ReplaySubject<ExtendedAlbum> { get }
    var headerTitle: ReplaySubject<String> { get }
    var goToLogin: PublishSubject<Void> { get }
    var showError: ReplaySubject<String> { get }
}

public protocol AlbumDetailsViewModelType {
    var inputs: AlbumDetailsViewModelInputs { get }
    var outputs: AlbumDetailsViewModelOutputs { get }
}

public final class AlbumDetailsViewModel: AlbumDetailsViewModelType, AlbumDetailsViewModelInputs, AlbumDetailsViewModelOutputs {
    private let albumRepository: AlbumRepository
    private let authRepository: AuthRepository
    private let disposeBag = DisposeBag()
    
    private var didTapOnHeartProperty = PublishSubject<Track>()
    public func didTapOnHeart(track: Track) {
        didTapOnHeartProperty.onNext(track)
    }
    
    public let albumDetails = ReplaySubject<ExtendedAlbum>.create(bufferSize: 1)
    public let headerTitle = ReplaySubject<String>.create(bufferSize: 1)
    public let goToLogin = PublishSubject<Void>()
    public let showError = ReplaySubject<String>.create(bufferSize: 1)
        
    public var inputs: AlbumDetailsViewModelInputs {
        return self
    }
    
    public var outputs: AlbumDetailsViewModelOutputs {
        return self
    }
    
    public init(album: Album, albumRepository: AlbumRepository, authRepository: AuthRepository) {
        self.albumRepository = albumRepository
        self.authRepository = authRepository
        
        headerTitle.onNext(album.title)
        
        let albumDetailsObservable = albumRepository
            .getAlbumDetails(id: album.mbid, username: "herkyjerky")
            .do(onError: { [weak self] error in
                self?.showError.onNext(error.localizedDescription)
            })
            .compactMap { $0 }
            .asObservable()
            .share()
        
        let didTapOnHeartObservable = didTapOnHeartProperty
            .asObservable()
            .share()
        
        didTapOnHeartObservable
            .map { _ in Void() }
            .filter { _ in !authRepository.isLoggedIn }
            .subscribe(goToLogin)
            .disposed(by: disposeBag)
        
        albumDetailsObservable
            .subscribe(albumDetails)
            .disposed(by: disposeBag)
    }
}

//
//  AlbumListViewModel.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 07/05/2021.
//

import RxSwift

public protocol AlbumViewModelInputs {
    func didSelectPeriod(period: Period)
    func willDisplayCell(at page: Int)
}

public protocol AlbumViewModelOutputs {
    var albums: PublishSubject<TopAlbums> { get }
    var nextPageAlbums: PublishSubject<TopAlbums> { get }
    var showHud: ReplaySubject<Bool> { get }
    var showError: ReplaySubject<String> { get }
}

public protocol AlbumViewModelType {
    var inputs: AlbumViewModelInputs { get }
    var outputs: AlbumViewModelOutputs { get }
}

public final class AlbumViewModel: AlbumViewModelType, AlbumViewModelInputs, AlbumViewModelOutputs {
    private let albumRepository: AlbumRepository
    private let disposeBag = DisposeBag()
    
    private var didSelectPeriodProperty = PublishSubject<Period>()
    public func didSelectPeriod(period: Period) {
        didSelectPeriodProperty.onNext(period)
    }
    
    private var willDisplayCellProperty = PublishSubject<Int>()
    public func willDisplayCell(at page: Int) {
        willDisplayCellProperty.onNext(page)
    }
    
    public let albums = PublishSubject<TopAlbums>()
    public let nextPageAlbums = PublishSubject<TopAlbums>()
    public let showHud = ReplaySubject<Bool>.create(bufferSize: 1)
    public let showError = ReplaySubject<String>.create(bufferSize: 1)
        
    public var inputs: AlbumViewModelInputs {
        return self
    }
    
    public var outputs: AlbumViewModelOutputs {
        return self
    }
    
    private var previousPeriod: Period = ._12month
    private var currentPage: Int = 0
        
    public init(albumRepository: AlbumRepository) {
        self.albumRepository = albumRepository
    
        let albumsObservable = Observable
            .combineLatest(
                didSelectPeriodProperty.startWith(previousPeriod),
                willDisplayCellProperty.startWith(1).distinctUntilChanged()
            )
            .flatMap { [weak self] (period, page) -> Single<TopAlbums> in
                guard let self = self, period != self.previousPeriod || page != self.currentPage else {
                    return .never()
                }
                
                self.currentPage = self.previousPeriod == period ? page : 1
                self.previousPeriod = period

                return albumRepository.getTopAlbums(username: "herkyjerky", period: period, page: self.currentPage)
                    .do(onError: { [weak self] error in
                        self?.showError.onNext(error.localizedDescription)
                    }, onSubscribe: { [weak self] in
                        self?.showHud.onNext(true)
                    }, onSubscribed: { [weak self] in
                        self?.showHud.onNext(false)
                    })
            }
            .asObservable()
            .share()
        
        albumsObservable
            .filter { $0.pagingMeta.page <= 1 }
            .subscribe(albums)
            .disposed(by: disposeBag)
        
        albumsObservable
            .withLatestFrom(albums, resultSelector: { newAlbums, previousAlbums in
                guard newAlbums.pagingMeta.page > 1 else { return nil }
                
                let combinedAlbums = previousAlbums.albums + newAlbums.albums
                return TopAlbums(albums: combinedAlbums, pagingMeta: newAlbums.pagingMeta)
            })
            .compactMap { $0 }
            .subscribe(albums)
            .disposed(by: disposeBag)
    }
}

//
//  AlbumListViewModelTests.swift
//  lastfm-explorerTests
//
//  Created by Melānija Grunte on 08/05/2021.
//

import lastfm_explorer
import XCTest
import RxSwift
import RxTest

class AlbumListViewModelTests: XCTestCase {
    private let albumRepository = AlbumRepositoryMock()
    
    private var scheduler: TestScheduler! = TestScheduler(initialClock: 0)
    private var viewModel: AlbumViewModelType!
    private var disposeBag: DisposeBag!
    
    private var topAlbums: TestableObserver<TopAlbums>!
    private var closeScreen: TestableObserver<Void>!
        
    override func setUp() {
        super.setUp()
        
        let pagingMetaMock = PagingMeta(page: 1, perPage: 50, total: 249, totalPages: 5)
        let topAlbumsMock = TopAlbums(albums: [], pagingMeta: pagingMetaMock)
        
        albumRepository.getTopAlbumsUsernamePeriodPageReturnValue = Single.just(topAlbumsMock)
        
        viewModel = AlbumViewModel(albumRepository: albumRepository)
        disposeBag = DisposeBag()
        
        scheduler = TestScheduler(initialClock: 0)
        
        topAlbums = scheduler.createObserver(TopAlbums.self)

        viewModel.outputs.albums.subscribe(topAlbums).disposed(by: disposeBag)
    }
    
    override func tearDown() {
        disposeBag = nil
    }
    
    func testBasicFlowEventCount() {
        // Act
        viewModel.inputs.didSelectPeriod(period: ._overall)
        viewModel.inputs.willDisplayCell(at: 1)
        viewModel.inputs.willDisplayCell(at: 2)
        viewModel.inputs.willDisplayCell(at: 2)
        viewModel.inputs.didSelectPeriod(period: ._7day)
        
        // Assert
        XCTAssertEqual(topAlbums.events.count, 3)

        // Act
        viewModel.inputs.willDisplayCell(at: 1)

        // Assert
        XCTAssertNotEqual(topAlbums.events.count, 4)
    }
    
    func testCurrentPageInMeta() {
        // Act
        viewModel.inputs.didSelectPeriod(period: ._overall)
       
        // Assert
        XCTAssertEqual(
            topAlbums.events.last
                .map { $0.value.element?.pagingMeta.page },
            1
        )
    }
}

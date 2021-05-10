//
//  ViewControllers.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 08/05/2021.
//

import RxSwift

public class ViewControllers {
    public static var sharedInternal: ViewControllers!
    public static var shared: ViewControllers {
        guard let shared = sharedInternal else {
            fatalError("Initialize by calling ViewControllers.initialize(...) before use")
        }
        
        return shared
    }
    
    public static func initialize(authRepository: AuthRepository, albumRepository: AlbumRepository) {
        if sharedInternal != nil {
            fatalError("Can be initialized only once")
        }
        
        sharedInternal = ViewControllers(
            authRepository: authRepository,
            albumRepository: albumRepository
        )
    }
    
    private let authRepository: AuthRepository
    private let albumRepository: AlbumRepository
    
    private init(authRepository: AuthRepository, albumRepository: AlbumRepository) {
        self.authRepository = authRepository
        self.albumRepository = albumRepository
    }
    
    // MARK: - ViewControllers
    
    public func getLoginViewController() -> LoginViewController {
        let viewModel = LoginViewModel(authRepository: authRepository)
        return LoginViewController.instantiate(viewModel: viewModel)
    }
    
    public func getAlbumListViewController() -> AlbumListViewController {
        let viewModel = AlbumViewModel(albumRepository: albumRepository)
        return AlbumListViewController.instantiate(viewModel: viewModel)
    }
    
    public func getAlbumDetailsViewController(album: Album) -> AlbumDetailsViewController {
        let viewModel = AlbumDetailsViewModel(
            album: album,
            albumRepository: albumRepository,
            authRepository: authRepository
        )
        return AlbumDetailsViewController.instantiate(viewModel: viewModel)
    }
}

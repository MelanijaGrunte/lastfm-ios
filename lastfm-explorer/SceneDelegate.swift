//
//  SceneDelegate.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 07/05/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)

        let navigationController = UINavigationController()
            
        let listVC = ViewControllers.shared.getAlbumListViewController()
        
        navigationController.viewControllers = [listVC]
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.barTintColor = Colors.background
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.tintColor = Colors.text
                
        window.rootViewController = navigationController
        
        self.window = window
        window.makeKeyAndVisible()
    }
    
}


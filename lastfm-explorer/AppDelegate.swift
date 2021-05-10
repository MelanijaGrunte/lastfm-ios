//
//  AppDelegate.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 07/05/2021.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let api = Api()
        
        let authRepository = ConcreteAuthRepository(api: api)
        let albumRepository = ConcreteAlbumRepository(api: api)
        
        ViewControllers.initialize(authRepository: authRepository, albumRepository: albumRepository)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
}

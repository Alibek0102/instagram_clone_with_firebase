//
//  SceneDelegate.swift
//  InstagramClone
//
//  Created by Алибек Аблайулы on 31.08.2023.
//

import UIKit
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
//        window?.rootViewController = ViewController()
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible()
    }
}


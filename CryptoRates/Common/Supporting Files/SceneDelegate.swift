//
//  SceneDelegate.swift
//  CryptoCourses
//
//  Created by Владимир Беляев on 13.01.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let coursesViewController = RatesViewController()
        let navigationController = NavigationController(rootViewController: coursesViewController)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

}


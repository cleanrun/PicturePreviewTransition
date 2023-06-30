//
//  SceneDelegate.swift
//  PicturePreviewTransition
//
//  Created by cleanmac on 29/06/23.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private(set) var currentNavigationController: UINavigationController!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let listVC = ImageListViewController()
        currentNavigationController = UINavigationController(rootViewController: listVC)
        window!.rootViewController = currentNavigationController
        window!.makeKeyAndVisible()
    }

}


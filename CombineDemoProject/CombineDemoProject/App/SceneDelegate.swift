//
//  SceneDelegate.swift
//  CombineDemoProject
//
//  Created by Andrés Pesate on 07/07/2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		if let windowScene = scene as? UIWindowScene {
		    let window = UIWindow(windowScene: windowScene)
			window.rootViewController = NavigationController(rootViewController: TodoListViewController())
		    self.window = window
		    window.makeKeyAndVisible()
		}
	}

}


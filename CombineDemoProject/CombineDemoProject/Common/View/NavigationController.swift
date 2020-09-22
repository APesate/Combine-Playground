//
//  NavigationController.swift
//  CombineDemoProject
//
//  Created by Andrés Pesate on 07/07/2020.
//

import UIKit

final class NavigationController: UINavigationController {

	override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

	override func viewDidLoad() {
		super.viewDidLoad()
		applyTheme()
	}

}

extension NavigationController {

	private func applyTheme() {
		themeNavigationBar()
	}

	private func themeNavigationBar() {
		let navBarAppearance = UINavigationBarAppearance()
		navBarAppearance.configureWithOpaqueBackground()
		navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.bbBase, .font: UIFont.preferredFont(forTextStyle: .headline)]
		navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.bbBase, .font: UIFont.preferredFont(forTextStyle: .largeTitle)]
		navBarAppearance.backgroundColor = .bbBlue

		navigationBar.prefersLargeTitles = true
		navigationBar.tintColor = .bbBase
		navigationBar.standardAppearance = navBarAppearance
		navigationBar.scrollEdgeAppearance = navBarAppearance
	}

}

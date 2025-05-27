//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by 양원식 on 5/26/25.
//
import UIKit

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let container: DIContainer
    
    init(window: UIWindow, container: DIContainer) {
        self.window = window
        self.container = container
    }
    
    func start() {
        let mainPageVC = container.weatherViewControllerFactory.makeMainPageViewController(coordinator: self)
        let nav = UINavigationController(rootViewController: mainPageVC)
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
    
    func presentSearchView(from viewController: UIViewController, onDismiss: @escaping (Location?) -> Void) {
        let searchVC = container.searchViewControllerFactory.makeSearchViewController(onDismiss: onDismiss)
        viewController.navigationController?.pushViewController(searchVC, animated: true)
    }
}

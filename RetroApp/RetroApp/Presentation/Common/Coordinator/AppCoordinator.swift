//
//  AppCoordinator.swift
//  RetroApp
//
//  Created by J on 3/30/26.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let diContainer: DIContainer
    private let window: UIWindow

    init(navigationController: UINavigationController, diContainer: DIContainer, window: UIWindow) {
        self.navigationController = navigationController
        self.diContainer = diContainer
        self.window = window
    }

    func start() {
        Task {
            await diContainer.builtInFormatSeeder.seedIfNeeded()
        }

        let viewModel = RetrospectListViewModel(fetchRetrospectListUseCase: diContainer.fetchRetrospectListUseCase)

        let viewController = RetrospectListViewController(viewModel: viewModel)
        navigationController.viewControllers = [viewController]

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

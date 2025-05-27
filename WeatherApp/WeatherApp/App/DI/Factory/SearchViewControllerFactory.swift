//
//  SearchViewControllerFactory.swift
//  WeatherApp
//
//  Created by 양원식 on 5/26/25.
//

final class SearchViewControllerFactory {
    private let viewModelFactory: SearchViewModelFactory

    init(viewModelFactory: SearchViewModelFactory) {
        self.viewModelFactory = viewModelFactory
    }

    func makeSearchViewController(
        coordinator: AppCoordinator,
        onDismiss: @escaping (Location?) -> Void
    ) -> SearchViewController {
        let viewModel = viewModelFactory.makeSearchViewModel()
        let vc = SearchViewController(viewModel: viewModel, coordinator: coordinator)
        vc.onDismiss = onDismiss
        vc.coordinator = coordinator
        return vc
    }
}

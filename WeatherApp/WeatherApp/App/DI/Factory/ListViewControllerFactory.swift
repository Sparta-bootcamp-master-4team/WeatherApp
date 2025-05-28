//
//  ListViewControllerFactory.swift
//  WeatherApp
//
//  Created by 양원식 on 5/26/25.
//

final class ListViewControllerFactory {
    private let viewModelFactory: ListViewModelFactory

    init(viewModelFactory: ListViewModelFactory) {
        self.viewModelFactory = viewModelFactory
    }

    func makeListViewController(coordinator: AppCoordinator) -> ListViewController {
        let viewModel = viewModelFactory.makeListViewModel()
        return ListViewController(viewModel: viewModel, coordinator: coordinator)
    }
}


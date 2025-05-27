//
//  WeatherViewControllerFactory.swift
//  WeatherApp
//
//  Created by 양원식 on 5/26/25.
//
import UIKit

final class WeatherViewControllerFactory {
    private let viewModelFactory: WeatherViewModelFactory

    init(viewModelFactory: WeatherViewModelFactory) {
        self.viewModelFactory = viewModelFactory
    }

    func makeMainPageViewController(coordinator: AppCoordinator) -> MainPageViewController {
        let mainVM = viewModelFactory.makeMainViewModel()
        let detailVM = viewModelFactory.makeMainDetailViewModel(mainVM: mainVM)
        let pageVM = viewModelFactory.makePageViewModel()

        return MainPageViewController(
            viewModel: pageVM,
            mainViewModel: mainVM,
            mainDetailViewModel: detailVM,
            coordinator: coordinator
        )
    }
}

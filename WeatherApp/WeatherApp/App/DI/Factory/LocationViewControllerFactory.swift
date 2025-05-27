//
//  LocationViewControllerFactory.swift
//  WeatherApp
//
//  Created by 양원식 on 5/27/25.
//

// LocationViewControllerFactory.swift
final class LocationViewControllerFactory {
    private let weatherVMFactory: WeatherViewModelFactory
    
    init(weatherVMFactory: WeatherViewModelFactory) {
        self.weatherVMFactory = weatherVMFactory
    }
    
    func makeLocationPageViewController(
        coordinator: AppCoordinator,
        location: Location
    ) -> LocationPageViewController {
        let mainVM = weatherVMFactory.makeLocationViewModel(location: location)
        let detailVM = weatherVMFactory.makeLocationDetailViewModel(mainVM: mainVM)
        let pageVM = weatherVMFactory.makePageViewModel()

        return LocationPageViewController(
            viewModel: pageVM,
            mainViewModel: mainVM,
            detailViewModel: detailVM,
            coordinator: coordinator
        )
    }
}

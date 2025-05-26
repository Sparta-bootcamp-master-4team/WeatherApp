//
//  DIContainer.swift
//  WeatherApp
//
//  Created by 양원식 on 5/26/25.
//

final class DIContainer {
    let weatherViewModelFactory = WeatherViewModelFactory()
    let listViewModelFactory = ListViewModelFactory()

    lazy var weatherViewControllerFactory: WeatherViewControllerFactory = {
        WeatherViewControllerFactory(viewModelFactory: weatherViewModelFactory)
    }()

    lazy var listViewControllerFactory: ListViewControllerFactory = {
        ListViewControllerFactory(viewModelFactory: listViewModelFactory)
    }()
    
    let searchViewModelFactory = SearchViewModelFactory()
    lazy var searchViewControllerFactory = SearchViewControllerFactory(viewModelFactory: searchViewModelFactory)

}


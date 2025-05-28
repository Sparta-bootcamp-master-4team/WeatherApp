//
//  ListViewModelFactory.swift
//  WeatherApp
//
//  Created by 양원식 on 5/26/25.
//

final class ListViewModelFactory {
    func makeListViewModel() -> ListViewModel {
        let repo = CoreDataLocationRepository()
        return ListViewModel(
            fetchLocationsUseCase: FetchLocationsUseCase(repository: repo),
            deleteLocationUseCase: DeleteLocationUseCase(repository: repo),
            saveLocationUseCase: SaveLocationUseCase(repository: repo)
        )
    }
}

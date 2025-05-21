//
//  SearchDongsUseCase.swift
//  WeatherApp
//
//  Created by tlswo on 5/21/25.
//

final class SearchDongsUseCase: SearchDongsUseCaseProtocol {

    private let repository: GeocodingRepositoryProtocol

    init(repository: GeocodingRepositoryProtocol) {
        self.repository = repository
    }

    func execute(query: String) -> [String] {
        return repository.searchDongs(matching: query)
    }
}

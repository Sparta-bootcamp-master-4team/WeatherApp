//
//  SearchDongsUseCase.swift
//  WeatherApp
//
//  Created by tlswo on 5/21/25.
//

// MARK: - SearchDongsUseCase

final class SearchDongsUseCase: SearchDongsUseCaseProtocol {

    // MARK: - Properties

    private let repository: GeocodingRepositoryProtocol

    // MARK: - Initializer

    init(repository: GeocodingRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Public Methods

    func execute(query: String) -> [String] {
        return repository.searchDongs(matching: query)
    }
}

//
//  FetchCoordinateUseCase.swift
//  WeatherApp
//
//  Created by tlswo on 5/21/25.
//

import RxSwift

// MARK: - FetchCoordinateUseCase

final class FetchCoordinateUseCase: FetchCoordinateUseCaseProtocol {

    // MARK: - Properties

    private let repository: GeocodingRepositoryProtocol

    // MARK: - Initializer

    init(repository: GeocodingRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Public Methods

    func execute(query: String) -> Single<Location?> {
        return repository.fetchCoordinate(for: query)
    }
}

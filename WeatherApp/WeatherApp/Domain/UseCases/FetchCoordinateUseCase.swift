//
//  FetchCoordinateUseCase.swift
//  WeatherApp
//
//  Created by tlswo on 5/21/25.
//

import RxSwift

final class FetchCoordinateUseCase: FetchCoordinateUseCaseProtocol {

    private let repository: GeocodingRepositoryProtocol

    init(repository: GeocodingRepositoryProtocol) {
        self.repository = repository
    }

    func execute(query: String) -> Single<Location?> {
        return repository.fetchCoordinate(for: query)
    }
}

//
//  FetchLocationsUseCase.swift
//  WeatherApp
//
//  Created by tlswo on 5/22/25.
//

import RxSwift

// MARK: - UseCase

final class FetchLocationsUseCase: FetchLocationsUseCaseProtocol {

    // MARK: - Dependencies

    private let repository: CoreDataLocationRepositoryProtocol

    // MARK: - Initializer

    init(repository: CoreDataLocationRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Public Methods

    func execute() -> Single<[Location]> {
        return repository.fetchAll()
    }
}

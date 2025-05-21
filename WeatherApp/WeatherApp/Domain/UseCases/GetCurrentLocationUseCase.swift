//
//  GetCurrentLocationUseCase.swift
//  WeatherApp
//
//  Created by tlswo on 5/21/25.
//

import CoreLocation
import RxSwift

// MARK: - GetCurrentLocationUseCase

final class GetCurrentLocationUseCase: GetCurrentLocationUseCaseProtocol {

    // MARK: - Properties

    private let repository: LocationRepositoryProtocol

    // MARK: - Initializer

    init(repository: LocationRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Public Methods

    func execute() -> Single<CLLocationCoordinate2D> {
        return repository.fetchCurrentLocation()
    }
}

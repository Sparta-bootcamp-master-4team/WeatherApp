//
//  LocationRepository.swift
//  WeatherApp
//
//  Created by tlswo on 5/21/25.
//

import CoreLocation
import RxSwift

// MARK: - LocationRepository

final class LocationRepository: LocationRepositoryProtocol {

    // MARK: - Properties

    private let locationService: LocationServiceProtocol

    // MARK: - Initializer

    init(locationService: LocationServiceProtocol) {
        self.locationService = locationService
    }

    // MARK: - Public Methods

    func fetchCurrentLocation() -> Single<CLLocationCoordinate2D> {
        return locationService.requestCurrentLocation()
    }
}

//
//  LocationRepositoryProtocol.swift
//  WeatherApp
//
//  Created by tlswo on 5/21/25.
//

import CoreLocation
import RxSwift

// MARK: - LocationRepositoryProtocol

protocol LocationRepositoryProtocol {

    // MARK: - Public Methods

    func fetchCurrentLocation() -> Single<CLLocationCoordinate2D>
}

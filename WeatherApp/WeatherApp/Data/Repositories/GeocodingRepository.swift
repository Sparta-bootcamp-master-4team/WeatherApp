//
//  GeocodingRepository.swift
//  WeatherApp
//
//  Created by 양원식 on 5/20/25.
//

import RxSwift

// MARK: - GeocodingRepository

final class GeocodingRepository: GeocodingRepositoryProtocol {

    // MARK: - Properties

    private let service: GeocodingServiceProtocol

    // MARK: - Initializer

    init(service: GeocodingServiceProtocol) {
        self.service = service
    }

    // MARK: - Public Methods

    func fetchCoordinate(for query: String) -> Single<Location?> {
        return service.fetchCoordinate(for: query)
    }

    func searchDongs(matching query: String) -> [String] {
        return service.searchDongs(matching: query)
    }
}

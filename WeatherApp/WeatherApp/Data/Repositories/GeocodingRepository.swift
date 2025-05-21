//
//  GeocodingRepository.swift
//  WeatherApp
//
//  Created by 양원식 on 5/20/25.
//

import RxSwift

final class GeocodingRepository: GeocodingRepositoryProtocol {

    private let service: GeocodingServiceProtocol

    init(service: GeocodingServiceProtocol) {
        self.service = service
    }

    func fetchCoordinate(for query: String) -> Single<Location?> {
        return service.fetchCoordinate(for: query)
    }

    func searchDongs(matching query: String) -> [String] {
        return service.searchDongs(matching: query)
    }
}

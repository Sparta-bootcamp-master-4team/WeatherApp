//
//  GeocodingRepositoryProtocol.swift
//  WeatherApp
//
//  Created by 양원식 on 5/20/25.
//

import RxSwift

// MARK: - GeocodingRepositoryProtocol

protocol GeocodingRepositoryProtocol {
    
    // MARK: - Coordinate Fetching

    func fetchCoordinate(for query: String) -> Single<Location?>

    // MARK: - Public Methods

    func searchDongs(matching query: String) -> [String]
}

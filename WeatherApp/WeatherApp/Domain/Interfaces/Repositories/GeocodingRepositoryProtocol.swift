//
//  GeocodingRepositoryProtocol.swift
//  WeatherApp
//
//  Created by 양원식 on 5/20/25.
//

import RxSwift

protocol GeocodingRepositoryProtocol {
    func fetchCoordinate(for query: String) -> Single<Location?>
    func searchDongs(matching query: String) -> [String]
}

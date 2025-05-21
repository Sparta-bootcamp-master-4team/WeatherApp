//
//  ReverseGeocodingRepositoryProtocol.swift
//  WeatherApp
//
//  Created by tlswo on 5/21/25.
//

import Foundation
import RxSwift

// MARK: - ReverseGeocodingRepositoryProtocol

protocol ReverseGeocodingRepositoryProtocol {
    
    // MARK: - Public Methods

    func fetchAddress(x: Double, y: Double) -> Single<String>
}

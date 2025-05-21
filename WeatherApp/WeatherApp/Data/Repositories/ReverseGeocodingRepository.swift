//
//  ReverseGeocodingRepository.swift
//  WeatherApp
//
//  Created by tlswo on 5/21/25.
//

import Foundation
import RxSwift

// MARK: - Repository

final class ReverseGeocodingRepository: ReverseGeocodingRepositoryProtocol {
    
    // MARK: - Dependencies

    private let reverseGeocodingService: ReverseGeocodingServiceProtocol

    // MARK: - Initializer

    init(reverseGeocodingService: ReverseGeocodingServiceProtocol) {
        self.reverseGeocodingService = reverseGeocodingService
    }

    // MARK: - Public Methods

    func fetchAddress(x: Double, y: Double) -> Single<String> {
        return reverseGeocodingService.fetchAddressName(x: x, y: y)
    }
}

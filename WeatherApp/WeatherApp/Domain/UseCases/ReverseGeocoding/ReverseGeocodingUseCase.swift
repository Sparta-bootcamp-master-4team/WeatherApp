//
//  ReverseGeocodingUseCase.swift
//  WeatherApp
//
//  Created by tlswo on 5/21/25.
//

import Foundation
import RxSwift

// MARK: - UseCase

final class ReverseGeocodingUseCase: ReverseGeocodingUseCaseProtocol {
    
    // MARK: - Dependencies

    private let repository: ReverseGeocodingRepositoryProtocol

    // MARK: - Initializer

    init(repository: ReverseGeocodingRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Public Methods

    func getAddressFromCoordinates(x: Double, y: Double) -> Single<String> {
        return repository.fetchAddress(x: x, y: y)
    }
}

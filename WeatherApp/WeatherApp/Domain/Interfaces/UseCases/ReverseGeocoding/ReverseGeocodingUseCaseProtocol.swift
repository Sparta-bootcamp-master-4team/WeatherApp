//
//  ReverseGeocodingUseCaseProtocol.swift
//  WeatherApp
//
//  Created by tlswo on 5/21/25.
//

import Foundation
import RxSwift

// MARK: - ReverseGeocodingUseCaseProtocol

protocol ReverseGeocodingUseCaseProtocol {
    
    // MARK: - Public Methods
    
    func getAddressFromCoordinates(x: Double, y: Double) -> Single<String>
}

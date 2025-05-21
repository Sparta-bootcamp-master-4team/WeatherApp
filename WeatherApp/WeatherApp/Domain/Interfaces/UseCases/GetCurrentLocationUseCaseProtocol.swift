//
//  GetCurrentLocationUseCaseProtocol.swift
//  WeatherApp
//
//  Created by tlswo on 5/21/25.
//

import CoreLocation
import RxSwift

// MARK: - GetCurrentLocationUseCaseProtocol

protocol GetCurrentLocationUseCaseProtocol {

    // MARK: - Public Methods

    func execute() -> Single<CLLocationCoordinate2D>
}

//
//  FetchLocationsUseCaseProtocol.swift
//  WeatherApp
//
//  Created by tlswo on 5/22/25.
//

import RxSwift

// MARK: - FetchLocationsUseCaseProtocol

protocol FetchLocationsUseCaseProtocol {
    
    // MARK: - UseCase Execution
    
    func execute() -> Single<[Location]>
}

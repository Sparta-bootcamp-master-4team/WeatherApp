//
//  DeleteLocationUseCaseProtocol.swift
//  WeatherApp
//
//  Created by tlswo on 5/22/25.
//

import RxSwift

// MARK: - DeleteLocationUseCaseProtocol

protocol DeleteLocationUseCaseProtocol {
    
    // MARK: - UseCase Execution

    func execute(_ location: Location) -> Completable
}

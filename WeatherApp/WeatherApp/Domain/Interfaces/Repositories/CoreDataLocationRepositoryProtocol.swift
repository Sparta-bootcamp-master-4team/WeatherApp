//
//  CoreDataLocationRepositoryProtocol.swift
//  WeatherApp
//
//  Created by tlswo on 5/22/25.
//

import RxSwift

// MARK: - CoreDataLocationRepositoryProtocol

protocol CoreDataLocationRepositoryProtocol {
    
    // MARK: Public Methods
    
    func save(_ location: Location) -> Completable
    
    func fetchAll() -> Single<[Location]>
    
    func delete(_ location: Location) -> Completable
}

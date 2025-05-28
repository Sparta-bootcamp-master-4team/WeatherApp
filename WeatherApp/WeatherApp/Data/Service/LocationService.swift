//
//  LocationManager.swift
//  WeatherApp
//
//  Created by tlswo on 5/21/25.
//

import Foundation
import CoreLocation
import RxSwift

// MARK: - Protocol

protocol LocationServiceProtocol {
    func requestCurrentLocation() -> Single<CLLocationCoordinate2D>
}

// MARK: - LocationService

final class LocationService: NSObject, LocationServiceProtocol {

    // MARK: - Properties

    private let locationManager = CLLocationManager()
    private let locationSubject = PublishSubject<CLLocationCoordinate2D>()

    // MARK: - Initializer

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // MARK: - Public Methods

    func requestCurrentLocation() -> Single<CLLocationCoordinate2D> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(NSError(domain: "", code: -1)))
                return Disposables.create()
            }

            let status = self.locationManager.authorizationStatus
            switch status {
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
            case .denied, .restricted:
                single(.failure(NSError(domain: "LocationAccessDenied", code: 1)))
                return Disposables.create()
            case .authorizedWhenInUse, .authorizedAlways:
                self.locationManager.requestLocation()
            @unknown default:
                single(.failure(NSError(domain: "UnknownAuthStatus", code: 2)))
                return Disposables.create()
            }

            let disposable = self.locationSubject
                .take(1)
                .subscribe(onNext: { coordinate in
                    single(.success(coordinate))
                }, onError: { error in
                    single(.failure(error))
                })

            return Disposables.create {
                disposable.dispose()
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.first?.coordinate {
            locationSubject.onNext(coordinate)
        } else {
            locationSubject.onError(NSError(domain: "LocationNotFound", code: 3))
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationSubject.onError(error)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            locationManager.requestLocation()
        }
    }
}

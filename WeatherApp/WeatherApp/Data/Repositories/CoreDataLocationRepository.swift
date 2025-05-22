//
//  CoreDataLocationRepository.swift
//  WeatherApp
//
//  Created by tlswo on 5/22/25.
//

import CoreData
import RxSwift

// MARK: - CoreDataLocationRepository

final class CoreDataLocationRepository: CoreDataLocationRepositoryProtocol {
    
    // MARK: - Properties
    
    private let persistentContainer: NSPersistentContainer

    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Initializer
    
    init(container: NSPersistentContainer = NSPersistentContainer(name: "Model")) {
        self.persistentContainer = container
        self.persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data stack init failed: \(error)")
            }
        }
    }
    
    // MARK: - Public Methods

    func save(_ location: Location) -> Completable {
        return Completable.create { [weak self] completable in
            self?.context.perform {
                let entity = Entity(context: self!.context)
                entity.name = location.name
                entity.latitude = location.latitude
                entity.longitude = location.longitude

                do {
                    try self?.context.save()
                    completable(.completed)
                } catch {
                    completable(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    func fetchAll() -> Single<[Location]> {
        return Single.create { [weak self] single in
            self?.context.perform {
                let request: NSFetchRequest<Entity> = Entity.fetchRequest()

                do {
                    let results = try self?.context.fetch(request) ?? []
                    let locations = results.compactMap { entity -> Location? in
                        guard let name = entity.name,
                              let lat = entity.latitude,
                              let lon = entity.longitude else {
                            return nil
                        }
                        return Location(name: name, latitude: lat, longitude: lon)
                    }
                    single(.success(locations))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }

    func delete(_ location: Location) -> Completable {
        return Completable.create { [weak self] completable in
            self?.context.perform {
                let request: NSFetchRequest<Entity> = Entity.fetchRequest()
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                    NSPredicate(format: "name == %@", location.name),
                    NSPredicate(format: "latitude == %@", location.latitude),
                    NSPredicate(format: "longitude == %@", location.longitude)
                ])

                do {
                    let results = try self?.context.fetch(request) ?? []
                    results.forEach { self?.context.delete($0) }
                    try self?.context.save()
                    completable(.completed)
                } catch {
                    completable(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}

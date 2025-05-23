//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by 양원식 on 5/20/25.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class SearchViewModel: ViewModelProtocol {
    enum Input {
        case searchTextChanged(String)
        case didSelectTableViewCell(String)
    }
    
    struct Output {
        var searchDongResults = BehaviorRelay<[String]>(value: [])
        var searchCoordinatesResult = BehaviorRelay<Location?>(value: nil)
    }
    
    var input = PublishRelay<Input>()
    var output = Output()
    
    private let fetchCoordinateUseCase: FetchCoordinateUseCase
    private let searchDongsUseCase: SearchDongsUseCase
    var disposeBag = DisposeBag()
    
    init (
        fetchCoordinateUseCase: FetchCoordinateUseCase = FetchCoordinateUseCase(repository: GeocodingRepository(service: GeocodingService())),
        searchDongsUseCase: SearchDongsUseCase = SearchDongsUseCase(repository: GeocodingRepository(service: GeocodingService()))
    ) {
        self.fetchCoordinateUseCase = fetchCoordinateUseCase
        self.searchDongsUseCase = searchDongsUseCase
        
        bindInput()
    }
    
    private func bindInput() {
        input
            .subscribe { [weak self] input in
                guard let self else { return }
                
                switch input {
                case .searchTextChanged(let text):
                    let results = searchDong(query: text)
                    output.searchDongResults.accept(results)
                case .didSelectTableViewCell(let dong):
                    print(dong)
                    let result = fetchCoordinates(query: dong)
                    result
                        .asObservable()
                        .bind(to: output.searchCoordinatesResult)
                        .disposed(by: disposeBag)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func searchDong(query: String) -> [String] {
        searchDongsUseCase.execute(query: query)
    }
    
    private func fetchCoordinates(query: String) -> Single<Location?> {
        fetchCoordinateUseCase.execute(query: query)
    }
}

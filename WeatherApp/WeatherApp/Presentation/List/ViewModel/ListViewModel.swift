//
//  ListViewModel.swift
//  WeatherApp
//
//  Created by 권순욱 on 5/22/25.
//

import Foundation
import RxSwift
import RxRelay

final class ListViewModel: ViewModelProtocol {
    enum Input {
        case onAppear
        case didSelectTableViewCell(Location)
        case didDeleteTableViewCell(Location)
        case saveLocation(Location)
    }
    
    struct Output {
        var lists = BehaviorRelay<[Location]>(value: [])
        var selectedLocation: Observable<Location>
    }
    
    var input = PublishRelay<Input>()
    var output: Output
    
    private let fetchLocationsUseCase: FetchLocationsUseCase
    private let deleteLocationUseCase: DeleteLocationUseCase
    private let saveLocationUseCase: SaveLocationUseCase
    private let selectedLocationRelay = PublishRelay<Location>()
    var disposeBag = DisposeBag()
    
    init(
        fetchLocationsUseCase: FetchLocationsUseCase = FetchLocationsUseCase(repository: CoreDataLocationRepository()),
        deleteLocationUseCase: DeleteLocationUseCase = DeleteLocationUseCase(repository: CoreDataLocationRepository()),
        saveLocationUseCase: SaveLocationUseCase = SaveLocationUseCase(repository: CoreDataLocationRepository())
    ) {
        self.fetchLocationsUseCase = fetchLocationsUseCase
        self.deleteLocationUseCase = deleteLocationUseCase
        self.saveLocationUseCase = saveLocationUseCase
        
        self.output = Output(
            selectedLocation: selectedLocationRelay.asObservable()
        )
        
        bindInput()
    }
    
    private func bindInput() {
        input
            .subscribe { [weak self] input in
                guard let self else { return }
                
                switch input {
                // 최초 뷰 로드 시(view will appear 기준 적용): 코어 데이터 로드
                case .onAppear:
                    let fetched = fetchLocationsUseCase.execute()
                    fetched
                        .asObservable()
                        .bind(to: output.lists)
                        .disposed(by: disposeBag)
                // 테이블 뷰 셀 선택: 아직 기능 구현 없음. 날씨 정보 화면으로 이동 기능 구현해야 함.
                case .didSelectTableViewCell(let dong):
                    selectedLocationRelay.accept(dong)
                // 테이블 뷰 셀 삭제: 해당 데이터 2군데 삭제(뷰 모델 자체 변수, 코어 데이터)
                case .didDeleteTableViewCell(let dong):
                    var lists = output.lists.value
                    lists.removeAll { $0.name == dong.name }
                    output.lists.accept(lists)
                    let result = deleteLocationUseCase.execute(dong)
                    result
                        .subscribe {
                            print("delete success")
                        } onError: { error in
                            print("delete error: \(error)")
                        }
                        .disposed(by: disposeBag)
                // 검색 화면에서 사용자가 선택한 내용 저장: 2군데(뷰 모델 자체 변수, 코어 데이터)
                case .saveLocation(let dong):
                    var lists = output.lists.value
                    lists.append(dong)
                    output.lists.accept(lists)
                    let result = saveLocationUseCase.execute(dong)
                    result
                        .subscribe {
                            print("save success")
                        } onError: { error in
                            print("save error: \(error)")
                        }
                        .disposed(by: disposeBag)
                }
            }
            .disposed(by: disposeBag)
    }
}

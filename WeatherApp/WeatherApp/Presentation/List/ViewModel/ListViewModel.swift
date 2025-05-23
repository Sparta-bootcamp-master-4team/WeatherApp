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
        case onTapAddButton
        case didSelectTableViewCell(Location)
        case didDeleteTableViewCell(Location)
        case saveLocation(Location)
    }
    
    struct Output {
        var lists = BehaviorRelay<[Location]>(value: [])
    }
    
    var input = PublishRelay<Input>()
    var output = Output()
    
    private let fetchLocationsUseCase: FetchLocationsUseCase
    private let deleteLocationUseCase: DeleteLocationUseCase
    private let saveLocationUseCase: SaveLocationUseCase
    var disposeBag = DisposeBag()
    
    init(
        fetchLocationsUseCase: FetchLocationsUseCase = FetchLocationsUseCase(repository: CoreDataLocationRepository()),
        deleteLocationUseCase: DeleteLocationUseCase = DeleteLocationUseCase(repository: CoreDataLocationRepository()),
        saveLocationUseCase: SaveLocationUseCase = SaveLocationUseCase(repository: CoreDataLocationRepository())
    ) {
        self.fetchLocationsUseCase = fetchLocationsUseCase
        self.deleteLocationUseCase = deleteLocationUseCase
        self.saveLocationUseCase = saveLocationUseCase
        
        bindInput()
    }
    
    private func bindInput() {
        input
            .subscribe { [weak self] input in
                guard let self else { return }
                
                switch input {
                // 최초 뷰 로드 시(view will appear 기준 적용): 코어 데이터 로드
                case .onAppear:
                    print("on Appear")
                    let fetched = fetchLocationsUseCase.execute()
                    fetched
                        .asObservable()
                        .bind(to: output.lists)
                        .disposed(by: disposeBag)
                // 우측 상단 관심지역 추가(+) 버튼: 현재는 push controller 외 다른 기능 없으나 혹시 필요할지 몰라서 구현해 놓음.
                case .onTapAddButton:
                    print("on Tap Add Button")
                // 테이블 뷰 셀 선택: 아직 기능 구현 없음. 날씨 정보 화면으로 이동 기능 구현해야 함.
                case .didSelectTableViewCell(let dong):
                    print("did Select TableViewCell")
                    print("name: \(String(describing: dong.name)), latitude: \(String(describing: dong.latitude)), longitude: \(String(describing: dong.longitude))")
                // 테이블 뷰 셀 삭제: 해당 데이터 2군데 삭제(뷰 모델 자체 변수, 코어 데이터)
                case .didDeleteTableViewCell(let dong):
                    print("did Delete TableViewCell")
                    print("name: \(String(describing: dong.name)), latitude: \(String(describing: dong.latitude)), longitude: \(String(describing: dong.longitude))")
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
                    print("save Location")
                    print("name: \(String(describing: dong.name)), latitude: \(String(describing: dong.latitude)), longitude: \(String(describing: dong.longitude))")
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

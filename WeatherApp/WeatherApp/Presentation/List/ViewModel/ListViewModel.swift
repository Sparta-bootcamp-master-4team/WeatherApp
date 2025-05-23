//
//  ListViewModel.swift
//  WeatherApp
//
//  Created by 권순욱 on 5/22/25.
//

import Foundation
import RxSwift
import RxRelay

final class ListViewModel {
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
    
    private var disposeBag = DisposeBag()
    
    init() {
        bindInput()
    }
    
    private func bindInput() {
        input
            .subscribe { [weak self] input in
                guard let self else { return }
                
                switch input {
                case .onAppear:
                    print("on Appear")
                case .onTapAddButton:
                    print("on Tap Add Button")
                case .didSelectTableViewCell(let dong):
                    print("did Select TableViewCell")
                    print("name: \(String(describing: dong.name)), latitude: \(String(describing: dong.latitude)), longitude: \(String(describing: dong.longitude))")
                case .didDeleteTableViewCell(let dong):
                    print("did Delete TableViewCell")
                    print("name: \(String(describing: dong.name)), latitude: \(String(describing: dong.latitude)), longitude: \(String(describing: dong.longitude))")
                    var lists = output.lists.value
                    lists.removeAll { $0.name == dong.name }
                    output.lists.accept(lists)
                case .saveLocation(let dong):
                    print("save Location")
                    print("name: \(String(describing: dong.name)), latitude: \(String(describing: dong.latitude)), longitude: \(String(describing: dong.longitude))")
                    var lists = output.lists.value
                    lists.append(dong)
                    output.lists.accept(lists)
                }
            }
            .disposed(by: disposeBag)
    }
}

//
//  ViewController.swift
//  WeatherApp
//
//  Created by 양원식 on 5/20/25.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let geocodingService = GeocodingService()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        geocodingService.searchLocation(query: "판교")
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { locations in
                print("검색된 동 리스트:")
                locations.forEach { print($0.addressName) }
            }, onFailure: { error in
                print("실패: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }


}


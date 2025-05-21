//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by 양원식 on 5/20/25.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    private let searchView = SearchView()
    private let viewModel = SearchViewModel(fetchCoordinateUseCase: FetchCoordinateUseCase(repository: GeocodingRepository(service: GeocodingService())), searchDongsUseCase: SearchDongsUseCase(repository: GeocodingRepository(service: GeocodingService())))
    private var disposeBag = DisposeBag()
    
    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItem()
        
        bind()
    }

    private func setNavigationItem() {
        navigationItem.title = "주소 검색"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: nil)
    }
    
    private func bind() {
        // 우측 상단 화면 닫기 버튼
        navigationItem.rightBarButtonItem?.rx.tap
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] _ in
                print("close button tapped")
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        // 서치 바 텍스트 필드
        searchView.searchBar.rx.text
            .orEmpty
            .asDriver(onErrorDriveWith: .empty())
            .skip(1)
            .drive { [weak self] in
                self?.viewModel.input.accept(.searchTextChanged($0))
            }
            .disposed(by: disposeBag)
        
        // 동 검색결과를 테이블 뷰 셀에 반영
        viewModel.output.searchDongResults
            .asDriver(onErrorDriveWith: .empty())
            .drive(searchView.tableView.rx.items(
                cellIdentifier: SearchViewCell.reuseIdentifier,
                cellType: SearchViewCell.self)) {
                    _, element, cell in
                    cell.configureUI(text: element)
                }
            .disposed(by: disposeBag)
        
        // 테이블 뷰 셀 선택
        searchView.tableView.rx.modelSelected(String.self)
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] in
                self?.viewModel.input.accept(.didSelectTableViewCell($0))
            }
            .disposed(by: disposeBag)
        
        // 테이블 뷰 셀을 선택해서 받아온 위치정보 값
        viewModel.output.searchCoordinatesResult
            .asDriver(onErrorDriveWith: .empty())
            .skip(1)
            .drive {
                print("name: \(String(describing: $0?.name)), latitude: \(String(describing: $0?.latitude)), longitude: \(String(describing: $0?.longitude))")
            }
            .disposed(by: disposeBag)
    }
}

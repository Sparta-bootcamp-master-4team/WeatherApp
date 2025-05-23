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
    var onDismiss: ((Location?) -> Void)?
    
    private let searchView = SearchView()
    private let noResultsView = NoResultsView()
    private let viewModel = SearchViewModel(fetchCoordinateUseCase: FetchCoordinateUseCase(repository: GeocodingRepository(service: GeocodingService())), searchDongsUseCase: SearchDongsUseCase(repository: GeocodingRepository(service: GeocodingService())))
    private var disposeBag = DisposeBag()
    
    deinit {
        print("deinit SearchViewController")
        NotificationCenter.default.removeObserver(self)
    }
    
    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItem()
        
        bind()
        
        setNotificationCenter()
    }

    private func setNavigationItem() {
        navigationItem.title = "주소 검색"
        // navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: nil)
    }
    
    private func bind() {
        // 우측 상단 화면 닫기 버튼
//        navigationItem.rightBarButtonItem?.rx.tap
//            .asDriver(onErrorDriveWith: .empty())
//            .drive { [weak self] _ in
//                guard let self else { return }
//                
//                print("close button tapped")
//                dismiss(animated: true)
//                onDismiss?(viewModel.output.searchCoordinatesResult.value)
//            }
//            .disposed(by: disposeBag)
        
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
        
        // 동 검색결과가 없으면 결과없음 레이블 표시
        viewModel.output.searchDongResults
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] results in
                guard let self else { return }
                
                if results.isEmpty {
                    searchView.tableView.backgroundView = noResultsView
                } else {
                    searchView.tableView.backgroundView = nil
                }
            }
            .disposed(by: disposeBag)
        
        // 결과없음 레이블이 보일 때, 최근 검색어를 같이 표시(예: "ㅇㅇ"에 대한 검색 결과가 없습니다)
        searchView.searchBar.rx.text
            .orEmpty
            .asDriver(onErrorDriveWith: .empty())
            .skip(1)
            .drive { [weak self] in
                self?.noResultsView.update(searchText: $0)
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
            .drive { [weak self] in
                guard let self else { return }
                
                print("name: \(String(describing: $0?.name)), latitude: \(String(describing: $0?.latitude)), longitude: \(String(describing: $0?.longitude))")
                
                popViewController()
            }
            .disposed(by: disposeBag)
    }
    
    private func popViewController() {
        onDismiss?(viewModel.output.searchCoordinatesResult.value)
        
        // dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    // 키보드가 나타날 때, 테이블 뷰 셀 아래쪽이 가려지는 현상 방지
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        let keyboardHeight = keyboardFrame.height
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        searchView.tableView.contentInset = contentInsets
        searchView.tableView.scrollIndicatorInsets = contentInsets
    }

    @objc private func keyboardWillHide(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        searchView.tableView.contentInset = contentInsets
        searchView.tableView.scrollIndicatorInsets = contentInsets
    }
}

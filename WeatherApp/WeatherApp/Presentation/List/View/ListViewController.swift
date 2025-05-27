//
//  ListViewController.swift
//  WeatherApp
//
//  Created by 권순욱 on 5/22/25.
//

import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {
    private let listView = ListView()
    private let viewModel: ListViewModel
    private weak var coordinator: AppCoordinator?
    private var disposeBag = DisposeBag()
    
    init(viewModel: ListViewModel, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit ListViewController")
    }
    
    override func loadView() {
        view = listView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItem()
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.input.accept(.onAppear)
    }
    
    private func setNavigationItem() {
        navigationItem.title = "관심 지역"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func bind() {
        // 관심지역 정보(코어 데이터)를 화면에 로드
        viewModel.output.lists
            .asDriver(onErrorDriveWith: .empty())
            .drive(listView.tableView.rx.items(
                cellIdentifier: ListViewCell.reuseIdentifier,
                cellType: ListViewCell.self)) {
                    _, element, cell in
                    cell.configureUI(text: element.name)
                }
                .disposed(by: disposeBag)
        
        // 좌측 상단 뒤로 가기 버튼(현재 위치 날씨 화면으로)
        navigationItem.leftBarButtonItem?.rx.tap
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] _ in
                guard let self else { return }
                
                print("back button tapped")
            }
            .disposed(by: disposeBag)
        
        // 우측 상단 관심지역 추가 버튼
        navigationItem.rightBarButtonItem?.rx.tap
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] _ in
                guard let self else { return }
                
                print("add button tapped")
                pushSearchViewController()
            }
            .disposed(by: disposeBag)
        
        // 저장된 관심지역이 없으면 목록없음 레이블 표시
        viewModel.output.lists
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] results in
                guard let self else { return }
                
                let noResultsView = NoResultsView()
                noResultsView.configureUI(imageName: "list.bullet.rectangle.portrait", titleLabelText: "저장 목록 없음", descriptionLabelText: "관심 지역을 저장하면 여기에 표시됩니다.")
                
                if results.isEmpty {
                    listView.tableView.backgroundView = noResultsView
                } else {
                    listView.tableView.backgroundView = nil
                }
            }
            .disposed(by: disposeBag)
        
        // 테이블 뷰 셀 선택
        listView.tableView.rx.modelSelected(Location.self)
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] in
                self?.viewModel.input.accept(.didSelectTableViewCell($0))
            }
            .disposed(by: disposeBag)
        
        // 테이블 뷰 셀 삭제
        listView.tableView.rx.modelDeleted(Location.self)
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] in
                self?.viewModel.input.accept(.didDeleteTableViewCell($0))
            }
            .disposed(by: disposeBag)
    }
    
    private func pushSearchViewController() {
        coordinator?.presentSearchView(from: self) { [weak self] location in
            guard let self, let location else { return }
            self.viewModel.input.accept(.saveLocation(location))
        }
    }

}

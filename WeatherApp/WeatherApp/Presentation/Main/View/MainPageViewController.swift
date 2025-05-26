//
//  MainPageViewController.swift
//  WeatherApp
//
//  Created by 송규섭 on 5/21/25.
//

import UIKit

class MainPageViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let mainViewModel: MainViewModel
    private let mainDetailViewModel: MainDetailViewModel
    private let viewModel: PageViewModel
    private let coordinator: AppCoordinator
    private lazy var mainDetailVC = MainDetailViewController(viewModel: self.mainDetailViewModel)
    init(
        viewModel: PageViewModel,
        mainViewModel: MainViewModel,
        mainDetailViewModel: MainDetailViewModel,
        coordinator: AppCoordinator
    ) {
        self.viewModel = viewModel
        self.mainViewModel = mainViewModel
        self.mainDetailViewModel = mainDetailViewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    private lazy var mainVC = MainViewController(
        viewModel: self.mainViewModel,
        coordinator: self.coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

}

private extension MainPageViewController {
    func configure() {
        setStyle()
        setHierarchy()
        setConstraints()
        setActions()
    }

    func setStyle() {
        view.backgroundColor = .systemBackground
        scrollView.isPagingEnabled = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        scrollView.refreshControl = refreshControl
    }

    func setHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        [mainVC, mainDetailVC].forEach {
            addChild($0)
            $0.didMove(toParent: self)
        }
        contentView.addSubviews(views: mainVC.view, mainDetailVC.view)
    }

    func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(scrollView.snp.height).multipliedBy(2)
        }

        mainVC.view.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(scrollView.snp.height)
        }

        mainDetailVC.view.snp.makeConstraints {
            $0.top.equalTo(mainVC.view.snp.bottom)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(scrollView.snp.height)
        }
    }

    func setActions() {
        refreshControl.addTarget(self, action: #selector(handleRefreshView), for: .valueChanged)
    }

    @objc func handleRefreshView() {
        mainVC.refresh()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
}

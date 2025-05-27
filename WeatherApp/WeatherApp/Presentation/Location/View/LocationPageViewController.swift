//
//  LocationPageViewController.swift
//  WeatherApp
//
//  Created by shinyoungkim on 5/27/25.
//

import UIKit
import SnapKit

final class LocationPageViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let refreshControl = UIRefreshControl()

    private let mainViewModel: LocationViewModel
    private let detailViewModel: LocationDetailViewModel
    private let pageViewModel: PageViewModel
    private let coordinator: AppCoordinator

    private lazy var mainVC = LocationViewController(viewModel: mainViewModel)
    private lazy var detailVC = LocationDetailViewController(viewModel: detailViewModel)

    init(
        viewModel: PageViewModel,
        mainViewModel: LocationViewModel,
        detailViewModel: LocationDetailViewModel,
        coordinator: AppCoordinator
    ) {
        self.pageViewModel = viewModel
        self.mainViewModel = mainViewModel
        self.detailViewModel = detailViewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension LocationPageViewController {
    func configure() {
        setStyle()
        setHierarchy()
        setConstraints()
        setActions()
    }

    func setStyle() {
        view.backgroundColor = .systemBackground
        scrollView.isPagingEnabled = true
//        navigationController?.setNavigationBarHidden(true, animated: false)
        scrollView.refreshControl = refreshControl
    }

    func setHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        [mainVC, detailVC].forEach {
            addChild($0)
            $0.didMove(toParent: self)
        }
        contentView.addSubviews(views: mainVC.view, detailVC.view)
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

        detailVC.view.snp.makeConstraints {
            $0.top.equalTo(mainVC.view.snp.bottom)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(scrollView.snp.height)
        }
    }

    func setActions() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }

    @objc func handleRefresh() {
        mainVC.refresh()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
}

//
//  MainPageViewController.swift
//  WeatherApp
//
//  Created by 송규섭 on 5/21/25.
//

import UIKit
import RxSwift

class MainPageViewController: UIPageViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: PageViewModel
    private let mainViewModel: MainViewModel

    private lazy var mainVC = MainViewController(viewModel: self.mainViewModel)
    private lazy var mainDetailVC = MainDetailViewController(viewModel: self.mainViewModel)
    private lazy var pages: [UIViewController] = [
        mainVC, mainDetailVC
    ]

    init(viewModel: PageViewModel,
         mainViewModel: MainViewModel) {
        self.viewModel = viewModel
        self.mainViewModel = mainViewModel
        super.init(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
        dataSource = self
        delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setViewControllers([pages[0]], direction: .forward, animated: false)
        print("🟣 setViewControllers 호출됨")

        viewModel.currentPage
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] index in
                guard let self, index >= 0, index < self.pages.count else { return }
                self.setViewControllers([self.pages[index]], direction: .forward, animated: true)
            }).disposed(by: disposeBag)
    }

}

extension MainPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed,
           let visible = viewControllers?.first,
           let index = pages.firstIndex(of: visible) {
            viewModel.currentPage.accept(index)
        }
    }
}

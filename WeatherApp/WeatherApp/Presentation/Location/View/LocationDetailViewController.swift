//
//  LocationDetailViewController.swift
//  WeatherApp
//
//  Created by shinyoungkim on 5/27/25.
//

import UIKit
import RxSwift
import RxDataSources

final class LocationDetailViewController: UIViewController {
    private let viewModel: LocationDetailViewModel
    private let disposeBag = DisposeBag()

    private let upArrowImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(
            systemName: "chevron.up",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 16)
        )
        imageView.tintColor = .customGray
        imageView.image = image
        return imageView
    }()

    private let upNoticeLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(size: 16)
        label.textColor = .customGray
        label.text = "메인으로 가기"
        return label
    }()

    private let topStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()

    private let detailCollectionView: UICollectionView = {
        let collectionView = UICollectionView.withCompositionalLayout()
        collectionView.backgroundColor = .systemBackground
        collectionView.register(DailyWeatherCell.self, forCellWithReuseIdentifier: DailyWeatherCell.id)
        collectionView.register(HourlyWeatherCell.self, forCellWithReuseIdentifier: HourlyWeatherCell.id)
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.id
        )
        return collectionView
    }()

    typealias DataSource = RxCollectionViewSectionedReloadDataSource<MainSectionModel>

    private let dataSource = DataSource(
        configureCell: { _, collectionView, indexPath, item in
            switch item {
            case .dailyWeatherListItem(let dailyWeatherAndTempRange):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DailyWeatherCell.id,
                    for: indexPath
                ) as? DailyWeatherCell else {
                    return UICollectionViewCell()
                }
                cell.configure(
                    dailyWeather: dailyWeatherAndTempRange.dailyWeather[indexPath.item],
                    range: dailyWeatherAndTempRange.temperatureRange
                )
                return cell

            case .hourlyWeatherItem(let hourlyWeather):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HourlyWeatherCell.id,
                    for: indexPath
                ) as? HourlyWeatherCell else {
                    return UICollectionViewCell()
                }
                cell.configure(with: hourlyWeather)
                return cell
            }
        },
        configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.id,
                for: indexPath
            ) as? SectionHeaderView else {
                return UICollectionReusableView()
            }

            let section = dataSource.sectionModels[indexPath.section]
            switch section {
            case .daily(_, let header), .hourly(_, let header):
                headerView.titleLabel.text = header
            }

            return headerView
        }
    )

    init(viewModel: LocationDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension LocationDetailViewController {
    func configure() {
        setStyle()
        setHierarchy()
        setConstraints()
        setBindings()
    }

    func setStyle() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func setHierarchy() {
        view.addSubviews(views: topStackView, detailCollectionView)
        topStackView.addArrangedSubviews(views: upArrowImageView, upNoticeLabel)
    }

    func setConstraints() {
        topStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(140)
            $0.height.equalTo(40)
        }

        detailCollectionView.snp.makeConstraints {
            $0.top.equalTo(topStackView.snp.bottom).offset(20)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func setBindings() {
        viewModel.sections
            .bind(to: detailCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

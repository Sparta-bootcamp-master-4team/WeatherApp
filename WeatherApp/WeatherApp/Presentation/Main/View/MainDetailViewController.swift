//
//  MainDetailViewController.swift
//  WeatherApp
//
//  Created by 송규섭 on 5/21/25.
//

import UIKit
import RxSwift
import RxDataSources

class MainDetailViewController: UIViewController {
    private let viewModel: MainDetailViewModel
    
    private let disposeBag = DisposeBag()

    private let upArrowImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage.init(systemName: "chevron.up", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16))

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
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center

        return stackView
    }()

    private let detailCollectionView: UICollectionView = {
        let collectionView = UICollectionView.withCompositionalLayout()
        collectionView.backgroundColor = .systemBackground
        collectionView.register(DailyWeatherCell.self, forCellWithReuseIdentifier: DailyWeatherCell.id)
        collectionView.register(HourlyWeatherCell.self, forCellWithReuseIdentifier: HourlyWeatherCell.id)

        return collectionView
    }()

    typealias MainDataSource = RxCollectionViewSectionedReloadDataSource<MainSectionModel>

    let dataSource = MainDataSource(
        configureCell: {_, collectionView, indexPath, item in
            switch item {
            case .dailyWeatherListItem(let dailyWeatherAndTempRange):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DailyWeatherCell.id,
                    for: indexPath
                ) as? DailyWeatherCell else {
                    return UICollectionViewCell()
                }
                cell.configure(dailyWeather: dailyWeatherAndTempRange.dailyWeather[indexPath.item], range: dailyWeatherAndTempRange.temperatureRange)
                return cell
            case .hourlyWeatherItem(let hourlyWeather):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HourlyWeatherCell.id,
                    for: indexPath) as? HourlyWeatherCell else {
                    return UICollectionViewCell()
                }
                cell.configure(with: hourlyWeather)
                return cell
            }
        }
    )

    init(viewModel: MainDetailViewModel) {
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

private extension MainDetailViewController {
    func configure() {
        setStyle()
        setHierarchy()
        setConstraints()
        setBindinds()
    }

    func setStyle() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false) // 시스템이 navigationBar를 자동으로 보이도록 리셋하는 경우가 존재하기에
    }

    func setHierarchy() {
        view.addSubviews(views: topStackView, detailCollectionView)
        topStackView.addArrangedSubviews(views: upArrowImageView, upNoticeLabel)
    }

    func setConstraints() {
        topStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
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

    func setBindinds() {
        viewModel.sections
            .bind(to: detailCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

}

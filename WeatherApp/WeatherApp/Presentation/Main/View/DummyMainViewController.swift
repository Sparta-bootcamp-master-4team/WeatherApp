//
//  DummyMainViewController.swift
//  WeatherApp
//
//  Created by shinyoungkim on 5/21/25.
//

import UIKit
import SnapKit

// 사용 종료 후 삭제할 예정입니다.
class DummyMainViewController: UIViewController {
    private enum Section {
        case main
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, DummyDailyWeather>!
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createDailyLayout())
        cv.register(
            DailyWeatherCell.self,
            forCellWithReuseIdentifier: DailyWeatherCell.id
        )
        cv.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.id
        )
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupViews()
        setupConstraints()
        configureDataSource()
        applySnapshot()
    }
    
    private func setupViews() {
        [
            collectionView
        ].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func createHourlyLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(60),
            heightDimension: .absolute(60)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(60 * 5),
            heightDimension: .absolute(60)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 12, leading: 8, bottom: 28, trailing: 8)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func createDailyLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(40)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, DummyDailyWeather>(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyWeatherCell.id, for: indexPath) as? DailyWeatherCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: item)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader,
                  let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SectionHeaderView.id,
                    for: indexPath) as? SectionHeaderView else {
                return UICollectionReusableView()
            }
            header.configure(with: "요일별 날씨")
            return header
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DummyDailyWeather>()
        snapshot.appendSections([.main])
        snapshot.appendItems(dummyData(), toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func dummyData() -> [DummyDailyWeather] {
//        return [
//            DummyHourlyWeather(time: "10시", weatherIcon: "09n", temperature: "20"),
//            DummyHourlyWeather(time: "11시", weatherIcon: "09n", temperature: "22"),
//            DummyHourlyWeather(time: "12시", weatherIcon: "09n", temperature: "19"),
//            DummyHourlyWeather(time: "13시", weatherIcon: "09n", temperature: "18"),
//            DummyHourlyWeather(time: "14시", weatherIcon: "09n", temperature: "21"),
//            DummyHourlyWeather(time: "15시", weatherIcon: "09n", temperature: "23"),
//            DummyHourlyWeather(time: "16시", weatherIcon: "09n", temperature: "18"),
//            DummyHourlyWeather(time: "17시", weatherIcon: "09n", temperature: "21"),
//            DummyHourlyWeather(time: "18시", weatherIcon: "09n", temperature: "23")
//        ]
        return [
            DummyDailyWeather(date: "오늘", weatherIcon: "09n", pop: "10%", highTemperature: 28, lowTemperature: 16, weeklyHighTemperatures: 28, weeklyLowTemperatures: 16),
            DummyDailyWeather(date: "목", weatherIcon: "09n", pop: "20%", highTemperature: 26, lowTemperature: 17, weeklyHighTemperatures: 28, weeklyLowTemperatures: 16),
            DummyDailyWeather(date: "금", weatherIcon: "09n", pop: "70%", highTemperature: 23, lowTemperature: 18, weeklyHighTemperatures: 28, weeklyLowTemperatures: 16),
            DummyDailyWeather(date: "토", weatherIcon: "09n", pop: "80%", highTemperature: 24, lowTemperature: 19, weeklyHighTemperatures: 28, weeklyLowTemperatures: 16),
            DummyDailyWeather(date: "일", weatherIcon: "09n", pop: "30%", highTemperature: 25, lowTemperature: 18, weeklyHighTemperatures: 28, weeklyLowTemperatures: 16),
            DummyDailyWeather(date: "월", weatherIcon: "09n", pop: "10%", highTemperature: 27, lowTemperature: 17, weeklyHighTemperatures: 28, weeklyLowTemperatures: 16),
            DummyDailyWeather(date: "화", weatherIcon: "09n", pop: "15%", highTemperature: 26, lowTemperature: 18, weeklyHighTemperatures: 28, weeklyLowTemperatures: 16),
            DummyDailyWeather(date: "수", weatherIcon: "09n", pop: "90%", highTemperature: 22, lowTemperature: 16, weeklyHighTemperatures: 28, weeklyLowTemperatures: 16)
        ]
    }
}

struct DummyHourlyWeather: Hashable {
    let time: String
    let weatherIcon: String
    let temperature: String
}

struct DummyDailyWeather: Hashable {
    let date: String
    let weatherIcon: String
    let pop: String
    let highTemperature: CGFloat
    let lowTemperature: CGFloat
    let weeklyHighTemperatures: CGFloat
    let weeklyLowTemperatures: CGFloat
}

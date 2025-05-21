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
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, DummyHourlyWeather>!
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.register(
            HourlyWeatherCell.self,
            forCellWithReuseIdentifier: HourlyWeatherCell.id
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
    
    private func createLayout() -> UICollectionViewLayout {
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
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, DummyHourlyWeather>(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCell.id, for: indexPath) as? HourlyWeatherCell else {
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
            header.configure(with: "시간대별 날씨")
            return header
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DummyHourlyWeather>()
        snapshot.appendSections([.main])
        snapshot.appendItems(dummyData(), toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func dummyData() -> [DummyHourlyWeather] {
        return [
            DummyHourlyWeather(time: "10시", weatherIcon: "09n", temperature: "20"),
            DummyHourlyWeather(time: "11시", weatherIcon: "09n", temperature: "22"),
            DummyHourlyWeather(time: "12시", weatherIcon: "09n", temperature: "19"),
            DummyHourlyWeather(time: "13시", weatherIcon: "09n", temperature: "18"),
            DummyHourlyWeather(time: "14시", weatherIcon: "09n", temperature: "21"),
            DummyHourlyWeather(time: "15시", weatherIcon: "09n", temperature: "23"),
            DummyHourlyWeather(time: "16시", weatherIcon: "09n", temperature: "18"),
            DummyHourlyWeather(time: "17시", weatherIcon: "09n", temperature: "21"),
            DummyHourlyWeather(time: "18시", weatherIcon: "09n", temperature: "23")
        ]
    }
}

struct DummyHourlyWeather: Hashable {
    let time: String
    let weatherIcon: String
    let temperature: String
}

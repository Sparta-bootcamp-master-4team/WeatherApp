//
//  ViewController.swift
//  WeatherApp
//
//  Created by 양원식 on 5/20/25.
//

import UIKit
import RxSwift
import SnapKit
import RxDataSources

class MainViewController: UIViewController {
    private let viewModel: MainViewModel

    private let disposeBag = DisposeBag()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .nanumSquare(size: 20)

        return label
    }()

    private let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "plus"), for: .normal)
        button.tintColor = .label

        return button
    }()

    private let currentTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .nanumSquare(size: 72, weight: "L")

        return label
    }()

    private let minTempLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(size: 24, weight: "L")
        label.textColor = .customBlue

        return label
    }()

    private let maxTempLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(size: 24, weight: "L")
        label.textColor = .customRed

        return label
    }()

    private let tempStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8

        return stackView
    }()

    private let locationWeatherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .nanumSquare(size: 20)

        return label
    }()

    private let characterImageView: UIImageView = {
        let imageView = UIImageView()

        return imageView
    }()

    private let downArrowImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage.init(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16))

        imageView.tintColor = .customGray
        imageView.image = image

        return imageView
    }()

    private let downNoticeLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(size: 16)
        label.textColor = .customGray
        label.text = "날씨 더보기"

        return label
    }()

    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center

        return stackView
    }()

    init(viewModel: MainViewModel) {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("🔵 MainViewController viewWillAppear")
        viewModel.didEnterRelay.accept(())
    }

}

private extension MainViewController {
    func configure() {
        setStyle()
        setHierarchy()
        setConstraints()
        setBindinds()
    }

    func setStyle() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false) // 시스템이 navigationBar를 자동으로 보이도록 리셋하는 경우가 존재하기에
        // TODO: - 데이터 바인딩 될 시 해당 임시 데이터 삭제
        characterImageView.image = UIImage.clearSky
        dateLabel.text = "오늘 5월 21일"
        currentTempLabel.text = "27"
        minTempLabel.text = "18"
        maxTempLabel.text = "27"
    }

    func setHierarchy() {
        view.addSubviews(views: dateLabel, currentTempLabel, plusButton, tempStackView, characterImageView, locationWeatherLabel, bottomStackView)
        tempStackView.addArrangedSubviews(views: minTempLabel, maxTempLabel)
        bottomStackView.addArrangedSubviews(views: downNoticeLabel, downArrowImageView)
    }

    func setConstraints() {
        dateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(28)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
        }

        currentTempLabel.snp.makeConstraints {
            $0.leading.equalTo(dateLabel.snp.leading)
            $0.top.equalTo(dateLabel.snp.bottom).offset(40)
        }

        tempStackView.snp.makeConstraints {
            $0.top.equalTo(currentTempLabel.snp.bottom)
            $0.centerX.equalTo(currentTempLabel.snp.centerX)
            $0.height.equalTo(28)
        }

        plusButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(dateLabel.snp.centerY)
            $0.size.equalTo(32)
        }

        locationWeatherLabel.snp.makeConstraints {
            $0.bottom.equalTo(characterImageView.snp.top).offset(-20)
            $0.centerX.equalToSuperview()
        }

        characterImageView.snp.makeConstraints {
            $0.bottom.equalTo(bottomStackView.snp.top).offset(-20)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(320)
        }

        bottomStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(140)
            $0.height.equalTo(40)
        }
    }

    func setBindinds() {
        viewModel.currentTemp?
            .drive(currentTempLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.todayMaxTemp?
            .drive(maxTempLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.todayMinTemp?
            .drive(minTempLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.currentLocationText?
            .drive(locationWeatherLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
}

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
import Lottie

class MainViewController: UIViewController {
    private let viewModel: MainViewModel
    private weak var coordinator: AppCoordinator?

    private let disposeBag = DisposeBag()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .nanumSquare(size: 20)

        return label
    }()

    private let listButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 20)
        button.setImage(.init(systemName: "list.bullet", withConfiguration: configuration), for: .normal)
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

    private var animatedWeatherView: LottieAnimationView = {
        let lottieView = LottieAnimationView(name: "clear")
        lottieView.loopMode = .loop
        return lottieView
    }() // 날씨 별로 name을 다르게 붙여 적용

    private let locationWeatherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .nanumSquare(size: 20)
        label.numberOfLines = 2

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
    
    init(viewModel: MainViewModel, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure() // 한번 애니메이션 아이콘을 올리고 play를 해도 그 이후 업데이트 될 일이 있으면 play를 안하지 않나 테스트해봐야됨.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animatedWeatherView.stop()
    }

    func refresh() {
        viewModel.didEnterRelay.accept(())
        animatedWeatherView.play()
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

        viewModel.didEnterRelay.accept(())
        animatedWeatherView.play()
    }

    func setHierarchy() {
        view.addSubviews(views: dateLabel, currentTempLabel, listButton, tempStackView, characterImageView, animatedWeatherView, locationWeatherLabel, bottomStackView)
        tempStackView.addArrangedSubviews(views: minTempLabel, maxTempLabel)
        bottomStackView.addArrangedSubviews(views: downNoticeLabel, downArrowImageView)
    }

    func setConstraints() {
        dateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(28)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(12)
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

        listButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(dateLabel.snp.centerY)
            $0.size.equalTo(32)
        }

        animatedWeatherView.snp.makeConstraints {
            $0.bottom.equalTo(characterImageView.snp.top).offset(15)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(160)
        }

        locationWeatherLabel.snp.makeConstraints {
            $0.bottom.equalTo(animatedWeatherView.snp.top).offset(-12)
            $0.centerX.equalToSuperview()
        }

        characterImageView.snp.makeConstraints {
            $0.bottom.equalTo(bottomStackView.snp.top).offset(-10)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(280)
        }

        bottomStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(140)
            $0.height.equalTo(40)
        }
    }

    func setBindinds() {
        viewModel.currentTemp?
            .drive(onNext: { [weak self] value in
                guard let self else { return }
                self.currentTempLabel.text = value
                self.currentTempLabel.isHidden = value.isEmpty
            })
            .disposed(by: disposeBag)
        viewModel.todayMaxTemp?
            .drive(onNext: { [weak self] value in
                guard let self else { return }
                self.maxTempLabel.text = value
                self.maxTempLabel.isHidden = value.isEmpty
            })
            .disposed(by: disposeBag)
        viewModel.todayMinTemp?
            .drive(onNext: { [weak self] value in
                guard let self else { return }
                self.minTempLabel.text = value
                self.minTempLabel.isHidden = value.isEmpty
            })
            .disposed(by: disposeBag)
        viewModel.currentLocationText?
            .drive(onNext: { [weak self] value in
                guard let self else { return }

                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 6
                paragraphStyle.alignment = .center

                let attributedText = NSMutableAttributedString(
                    string: "\(value.location)은(는)\n",
                    attributes: [
                        .font : UIFont.nanumSquare(size: 20),
                        .paragraphStyle: paragraphStyle
                    ]
                )

                let boldText = NSAttributedString(
                    string: value.weather ?? "",
                    attributes: [
                        .font : UIFont.nanumSquare(size: 20, weight: "B"),
                        .paragraphStyle: paragraphStyle
                    ]
                )

                attributedText.append(boldText)
                self.locationWeatherLabel.attributedText = attributedText
                self.locationWeatherLabel.isHidden = attributedText.string.isEmpty
            })
            .disposed(by: disposeBag)
        viewModel.weatherCondition?
            .drive(onNext: { [weak self] value in
                guard let self else { return }
                self.characterImageView.image = value.icon
                self.animatedWeatherView.animation = LottieAnimation.named(value.animatedIconCode)
                self.animatedWeatherView.loopMode = .loop
                self.animatedWeatherView.play()
            })
            .disposed(by: disposeBag)
        viewModel.currentDate?
            .drive(onNext: { [weak self] value in
                guard let self else { return }
                self.dateLabel.text = value
            })
            .disposed(by: disposeBag)
        
        listButton.rx.tap
            .bind { [weak self] in
                guard let self else { return }
                self.coordinator?.replaceRootWithListView()
            }
            .disposed(by: disposeBag)
    }
}

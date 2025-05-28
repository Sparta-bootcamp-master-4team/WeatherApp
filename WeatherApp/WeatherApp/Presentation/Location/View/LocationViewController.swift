//
//  LocationViewController.swift
//  WeatherApp
//
//  Created by shinyoungkim on 5/27/25.
//

import UIKit
import RxSwift
import SnapKit
import Lottie

final class LocationViewController: UIViewController {
    private let viewModel: LocationViewModel
    private let disposeBag = DisposeBag()
    private weak var coordinator: AppCoordinator?
    
    private let backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .label
        return button
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .nanumSquare(size: 20)
        return label
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("추가", for: .normal)
        button.titleLabel?.font = .nanumSquare(size: 16)
        button.setTitleColor(.label, for: .normal)
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
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()

    private let animatedWeatherView: LottieAnimationView = {
        let view = LottieAnimationView(name: "clear")
        view.loopMode = .loop
        return view
    }()

    private let locationWeatherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .nanumSquare(size: 20)
        return label
    }()

    private let characterImageView: UIImageView = {
        return UIImageView()
    }()

    private let downArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .customGray
        imageView.image = UIImage(
            systemName: "chevron.down",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 16)
        )
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
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()

    init(viewModel: LocationViewModel, coordinator: AppCoordinator) {
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
        configure()
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

private extension LocationViewController {
    func configure() {
        setStyle()
        setHierarchy()
        setConstraints()
        setBindings()
    }

    func setStyle() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        viewModel.didEnterRelay.accept(())
        animatedWeatherView.play()
        
        if viewModel.isLocationSaved {
            saveButton.isHidden = true
        }
    }

    func setHierarchy() {
        view.addSubviews(views: backButton, dateLabel, saveButton, currentTempLabel, tempStackView, characterImageView, animatedWeatherView, locationWeatherLabel, bottomStackView)
        tempStackView.addArrangedSubviews(views: minTempLabel, maxTempLabel)
        bottomStackView.addArrangedSubviews(views: downNoticeLabel, downArrowImageView)
    }

    func setConstraints() {
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(28)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing).offset(8)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
        
        saveButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(28)
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

        animatedWeatherView.snp.makeConstraints {
            $0.bottom.equalTo(characterImageView.snp.top).offset(15)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(188)
        }

        locationWeatherLabel.snp.makeConstraints {
            $0.bottom.equalTo(animatedWeatherView.snp.top).offset(-20)
            $0.centerX.equalToSuperview()
        }

        characterImageView.snp.makeConstraints {
            $0.bottom.equalTo(bottomStackView.snp.top).offset(-10)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(300)
        }

        bottomStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(140)
            $0.height.equalTo(40)
        }
    }

    func setBindings() {
        backButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .bind(to: viewModel.saveLocationTrigger)
            .disposed(by: disposeBag)
        
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
                let attributedText = NSMutableAttributedString(
                    string: "\(value.location), ",
                    attributes: [.font : UIFont.nanumSquare(size: 20)]
                )

                let boldText = NSAttributedString(
                    string: value.weather ?? "",
                    attributes: [.font : UIFont.nanumSquare(size: 20, weight: "B")]
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
        
        viewModel.saveResult
            .bind { [weak self] result in
                switch result {
                case .success:
                    self?.coordinator?.replaceRootWithListView()
                case .failure(_):
                    self?.showAlert(title: "실패", message: "위치 저장 실패")
                }
            }
            .disposed(by: disposeBag)
    }
}

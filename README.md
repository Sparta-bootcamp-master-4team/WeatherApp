# 메이웨더(날씨앱)
> 사용자의 현재 위치 또는 검색한 지역을 기반으로 실시간 기상 정보를 제공하는 서비스 입니다.
> 복잡한 레이아웃 구성과 비동기 데이터 흐름을  **RxSwift**,  **Clean Architecture**,  **MVVM**,  **Coordinator**  패턴으로 설계한 팀 과제입니다.

# 소개
- ✅ 복잡한 **UI 컴포넌트 구성**과 SnapKit 디버깅 경험
- ✅ **RxSwift** 기반의 선언형 데이터 바인딩
- ✅ 네트워크 통신과 **CoreData** 저장소 연동
- ✅ **MVVM 기반 클린 아키텍처**
- ✅ **Coordinator Pattern**을 통한 화면 전환 및 흐름 관리
- ✅ **Kakao Local API**를 활용한 위치 검색 및 좌표 조회
- ✅ **OpenWeather API**를 활용한 실시간 날씨 데이터 수집 및 시각화
- ✅ 행정표준코드 기반 **법정동 데이터 수집 → GPT로 JSON 가공 → 로컬 자동완성 구현**
- ✅ **CompositionalLayout**을 활용한 시간대별·일별 날씨 UI 구성
- ✅ **UIPageViewController의 PTR 제약을 구조적으로 해결한 트러블슈팅 경험**
- ✅ **GPT 기반 날씨 캐릭터 에셋 제작 및 GIF 연동을 통한 감성 UI 구현**

# 역할 분담
- 송규섭: 메인 날씨 화면 구현, UIUX 디자인 
- 신재욱: 검색 모델, 위치 모델, 지역 모델 구현
- 김신영: 상세 날씨 화면 구현
- 권순욱: 관심지역 리스트, 검색 화면(뷰 ~ 뷰 모델)
- 양원식: 날씨 API, 관련 UseCase 및 Repository 구현, Coordinator 패턴 적용

# 주요 기능
- 현재 위치 기반 날씨 조회
- 지역 검색 및 자동 완성
- 시간대별 / 일별 날씨 예보
- 날씨 캐릭터 시각화
- 지역 저장 및 Core Data 연동
- Pull To Refresh 기능
- 페이징 기반 화면 구조
- DIContainer + Factory 기반 의존성 주입

# 프로젝트 구조
```
WeatherApp
├── App
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── Coordinator
│   │   ├── AppCoordinator.swift
│   │   └── Protocol
│   │       └── Coordinator.swift
│   └── DI
│       ├── DIContainer.swift
│       └── Factory
│           ├── ListViewControllerFactory.swift
│           ├── ListViewModelFactory.swift
│           ├── SearchViewControllerFactory.swift
│           ├── SearchViewModelFactory.swift
│           ├── WeatherViewControllerFactory.swift
│           └── WeatherViewFactory.swift
├── Common
│   └── Extensions
│       ├── Bundle+Keys.swift
│       ├── Date+.swift
│       ├── DateFormatter+.swift
│       ├── UICollectionView+.swift
│       ├── UIFont+.swift
│       ├── UIStackView+.swift
│       ├── UIView+.swift
│       └── ViewController+.swift
├── Data
│   ├── Repositories
│   │   ├── CoreDataLocationRepository.swift
│   │   ├── GeocodingRepository.swift
│   │   ├── LocationRepository.swift
│   │   ├── ReverseGeocodingRepository.swift
│   │   └── WeatherRepository.swift
│   └── Service
│       ├── GeocodingService.swift
│       ├── LocationService.swift
│       ├── ReverseGeocodingService.swift
│       └── WeatherAPIService.swift
├── Domain
│   ├── Entities
│   │   ├── CurrentWeather.swift
│   │   ├── DailyWeather.swift
│   │   ├── DailyWeatherAndTemperaturnRange.swift
│   │   ├── HourlyWeather.swift
│   │   ├── Location.swift
│   │   ├── Region.swift
│   │   ├── TemperatureInfo.swift
│   │   ├── TemperatureRange.swift
│   │   ├── WeatherDescription.swift
│   │   └── WeatherResponse.swift
│   ├── Enums
│   │   └── WeatherCondition.swift
│   ├── Interfaces
│   │   ├── Repositories
│   │   │   ├── CoreDataLocationRepositoryProtocol.swift
│   │   │   ├── GeocodingRepositoryProtocol.swift
│   │   │   ├── LocationRepositoryProtocol.swift
│   │   │   ├── ReverseGeocodingRepositoryProtocol.swift
│   │   │   └── WeatherRepositoryProtocol.swift
│   │   └── UseCases
│   │       ├── DeleteLocationUseCaseProtocol.swift
│   │       ├── FetchAllWeatherUseCaseProtocol.swift
│   │       ├── FetchCoordinateUseCaseProtocol.swift
│   │       ├── FetchCurrentWeatherUseCaseProtocol.swift
│   │       ├── FetchDailyTemperatureRangeUseCaseProtocol.swift
│   │       ├── FetchDailyWeatherUseCaseProtocol.swift
│   │       ├── FetchHourlyWeatherUseCaseProtocol.swift
│   │       ├── FetchLocationsUseCaseProtocol.swift
│   │       ├── GetCurrentLocationUseCaseProtocol.swift
│   │       ├── GetDailyWeatherAndTemperatureRangeUseCaseProtocol.swift
│   │       ├── ReverseGeocodingUseCaseProtocol.swift
│   │       ├── SaveLocationUseCaseProtocol.swift
│   │       └── SearchDongsUseCaseProtocol.swift
│   └── UseCases
│       ├── DeleteLocationUseCase.swift
│       ├── FetchCoordinateUseCase.swift
│       ├── FetchCurrentWeatherUseCase.swift
│       ├── FetchDailyTemperatureRangeUseCase.swift
│       ├── FetchDailyWeatherUseCase.swift
│       ├── FetchHourlyWeatherUseCase.swift
│       ├── FetchLocationsUseCase.swift
│       ├── FetchWeatherUseCase.swift
│       ├── GetCurrentLocationUseCase.swift
│       ├── GetDailyWeatherAndTemperaturnRangeUseCase.swift
│       ├── ReverseGeocodingUseCase.swift
│       ├── SaveLocationUseCase.swift
│       └── SearchDongsUseCase.swift
├── Presentation
│   ├── List
│   │   ├── View
│   │   │   ├── Cell
│   │   │   │   └── ListViewCell.swift
│   │   │   ├── ListView.swift
│   │   │   └── ListViewController.swift
│   │   └── ViewModel
│   │       └── ListViewModel.swift
│   ├── Main
│   │   ├── View
│   │   │   ├── Cell
│   │   │   │   ├── DailyWeatherCell.swift
│   │   │   │   └── HourlyWeatherCell.swift
│   │   │   ├── DailyTemperatureRange.swift
│   │   │   ├── MainDetailViewController.swift
│   │   │   ├── MainPageViewController.swift
│   │   │   ├── MainViewController.swift
│   │   │   ├── Section
│   │   │   │   ├── MainSectionModel.swift
│   │   │   │   └── SectionItem.swift
│   │   │   ├── Section.swift
│   │   │   └── SectionHeaderView.swift
│   │   └── ViewModel
│   │       ├── MainDetailViewModel.swift
│   │       ├── MainViewModel.swift
│   │       └── PageViewModel.swift
│   ├── Search
│   │   ├── View
│   │   │   ├── Cell
│   │   │   │   ├── NoResultsView.swift
│   │   │   │   └── SearchViewCell.swift
│   │   │   ├── SearchView.swift
│   │   │   └── SearchViewController.swift
│   │   └── ViewModel
│   │       └── SearchViewModel.swift
│   ├── Location
│   │   ├── View
│   │   │   ├── LocationDetailViewController.swift
│   │   │   ├── LocationPageViewController.swift
│   │   │   └── LocationViewController.swift
│   │   └── ViewModel
│   │       ├── LocationDetailViewModel.swift
│   │       └── LocationViewModel.swift
│   └── Protocol
│       └── ViewModelProtocol.swift
├── Resources
│   ├── Assets.xcassets
│   │   ├── AppIcon.appiconset
│   │   └── Contents.json
│   ├── dongList.json
│   ├── Fonts
│   │   ├── NanumSquareB.ttf
│   │   ├── NanumSquareEB.ttf
│   │   ├── NanumSquareL.ttf
│   │   └── NanumSquareR.ttf
│   ├── Info.plist
│   └── Secrets.xcconfig
└── WeatherApp.xcodeproj
```
# 시연 영상
https://github.com/user-attachments/assets/18e497e1-d56e-4900-95df-fe207a7da1e2

https://github.com/user-attachments/assets/a89f0bd0-6823-474c-b396-fcb4411e702a

# UIPageViewController + Pull to Refresh(PTR) 충돌 문제 트러블 슈팅 🚀
### **문제 상황**

날씨 앱의 메인 화면은 UIPageViewController 기반으로 구성되어 있으며, 위/아래로 스와이프하여 각각의 페이지를 이동할 수 있도록 설계되어 있습니다. 이 중 첫 번째 페이지(메인 날씨 화면)에서는 사용자가 아래로 끌어당겼을 때 **새로고침(Pull to Refresh)** 기능이 동작해야 했습니다.

하지만 기존 구조에서는 아래와 같은 **PTR 적용의 어려움**이 있었습니다:

1.  **PageViewController의 ScrollView에 직접 refreshControl을 적용** 
    → UIPageViewController의 내부 UIScrollView는 시스템 내부 동작을 위해 사용되므로 refreshControl이 정상 작동하지 않음.
    
2.  **첫 번째 페이지(MainViewController)의 최상위 뷰를 ScrollView로 설정하여 PTR 적용**
    → PageViewController의 스크롤 제스처와 중첩되어 충돌 발생.
    → 상위 UIScrollView와 하위 UIScrollView 간 제스처 우선순위, Bounce 이슈, SafeArea 충돌 등으로 원활한 UX 불가능.
    
### **해결 전략**
여러 시도 끝에, 기존의 UIPageViewController 구조를 **최상위 UIScrollView로 대체**하여 직접 페이지 전환을 구현하는 방식으로 전환했습니다.
-   UIScrollView를 최상위 컨테이너로 두고, 두 개의 UIViewController(메인/하위 페이지)를 **addChild, didMove를 이용해 자식 뷰컨트롤러로 관리**    
-   각 자식 VC의 view를 UIScrollView의 하위 뷰로 추가하고, 페이지 단위로 수직 스크롤이 가능하도록 **페이징 레이아웃 설정**
-   이제 첫 번째 페이지에서는 **기본 UIRefreshControl 사용이 가능**해졌으며, 스크롤과 PTR 동작이 서로 충돌하지 않음
### **이슈 & 해결 포인트**
-   SafeAreaInsets, Bounce 설정 등이 상위/하위 뷰 간 충돌을 일으킬 수 있어 레이아웃 정리에 주의가 필요
-   기존 페이지 전환 효과나 UX를 재현하려면 **페이징 로직과 애니메이션**을 별도로 구현해야 함

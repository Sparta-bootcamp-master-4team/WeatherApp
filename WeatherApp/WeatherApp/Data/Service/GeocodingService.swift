//
//  GeocodingService.swift
//  WeatherApp
//
//  Created by 양원식 on 5/20/25.
//

import Foundation
import RxSwift

protocol GeocodingServiceProtocol {
    func searchDongs(matching query: String) -> [String] 
    func fetchCoordinate(for query: String) -> Single<Location?>
}

final class GeocodingService: GeocodingServiceProtocol {

    private let apiKey = Bundle.main.kakaoAPIKey
    private let dongList: [String]

    init() {
        self.dongList = GeocodingService.loadDongList()
    }

    static private func loadDongList() -> [String] {
        guard let url = Bundle.main.url(forResource: "dongList", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let list = try? JSONDecoder().decode([String].self, from: data) else {
            print("동 리스트 로드 실패")
            return []
        }
        return list
    }

    func searchDongs(matching query: String) -> [String] {
        return dongList.filter { $0.contains(query) }
    }

    func fetchCoordinate(for dongName: String) -> Single<Location?> {
        return Single.create { single in
            guard let encoded = dongName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: "https://dapi.kakao.com/v2/local/search/address.json?query=\(encoded)") else {
                single(.failure(NSError(domain: "Invalid URL", code: -1)))
                return Disposables.create()
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("KakaoAK \(self.apiKey)", forHTTPHeaderField: "Authorization")

            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    single(.failure(error))
                    return
                }

                guard let data = data,
                      let decoded = try? JSONDecoder().decode(KakaoAddressResponse.self, from: data),
                      let address = decoded.documents.first?.address else {
                    single(.success(nil))
                    return
                }

                single(.success(Location(name: dongName, latitude: address.y, longitude: address.x)))
            }

            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}

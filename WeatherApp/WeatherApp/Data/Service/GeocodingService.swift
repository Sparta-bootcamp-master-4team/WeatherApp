//
//  GeocodingService.swift
//  WeatherApp
//
//  Created by 양원식 on 5/20/25.
//

import Foundation
import RxSwift

final class GeocodingService {

    private let session: URLSession
    private let apiKey: String

    init(session: URLSession = .shared) {
        self.session = session
        self.apiKey = Bundle.main.kakaoAPIKey
    }

    func searchLocation(query: String) -> Single<[Location]> {
        return Single.create { single in
            guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: "https://dapi.kakao.com/v2/local/search/keyword.json?query=\(encodedQuery)") else {
                single(.failure(NSError(domain: "Invalid URL", code: -1)))
                return Disposables.create()
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("KakaoAK \(self.apiKey)", forHTTPHeaderField: "Authorization")

            let task = self.session.dataTask(with: request) { data, _, error in
                if let error = error {
                    single(.failure(error))
                    return
                }

                guard let data = data,
                      let response = try? JSONDecoder().decode(LocationAPIResponse.self, from: data) else {
                    single(.failure(NSError(domain: "Decoding Error", code: -2)))
                    return
                }
                
                let filtered = response.documents.filter {
                    let lastWord = $0.addressName.components(separatedBy: " ").last ?? ""
                    return lastWord.hasSuffix("동") || lastWord.hasSuffix("읍") || lastWord.hasSuffix("면")
                }
                
                let unique = Dictionary(grouping: filtered, by: { $0.addressName })
                                    .compactMap { $0.value.first }

                single(.success(unique))
            }

            task.resume()

            return Disposables.create { task.cancel() }
        }
    }
}

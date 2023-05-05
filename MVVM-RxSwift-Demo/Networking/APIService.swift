//
//  APIService.swift
//  MVVM-RxSwift-Demo
//
//  Created by Armand Kaguermanov on 02/05/2023.
//

import Foundation
import Moya
import RxMoya
import RxSwift

protocol APIServiceProtocol {
    func fetchLaunches(query: [String: Any], options: [String: Any]) -> Single<[Launch]>
}

class APIService: APIServiceProtocol {
    private let provider = MoyaProvider<SpaceXAPI>()
    
    func fetchLaunches(query: [String: Any], options: [String: Any]) -> Single<[Launch]> {
        return provider.rx.request(
            .getLaunches(query: query, options: options))
            .filterSuccessfulStatusCodes()
            .map { response in
                do {
                    let launches = try response.map([Launch].self, atKeyPath: "docs", using: JSONDecoder(), failsOnEmptyData: false)
                    return launches
                } catch {
                    throw AppError.parsingFailed
                }
            }
            .catch { error -> Single<[Launch]> in
                print(error.localizedDescription)
                if let appError = error as? AppError {
                    return Single.error(appError)
                } else {
                    return Single.error(AppError.requestFailed)
                }
            }
    }
}

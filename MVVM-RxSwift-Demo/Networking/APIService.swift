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
    func fetchLaunches() -> Single<[Launch]>
}

class APIService: APIServiceProtocol {
    private let provider = MoyaProvider<SpaceXAPI>()
    
    func fetchLaunches() -> Single<[Launch]> {
        return provider.rx.request(.getLaunches)
            .filterSuccessfulStatusCodes()
            .map([Launch].self,
                 atKeyPath: "docs",
                 using: JSONDecoder(),
                 failsOnEmptyData: false)
            .catch { error -> Single<[Launch]> in
                print(error.localizedDescription)
                return Single.just([])
            }
    }
}

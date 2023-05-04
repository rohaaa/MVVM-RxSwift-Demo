//
//  ListViewModel.swift
//  MVVM-RxSwift-Demo
//
//  Created by Armand Kaguermanov on 02/05/2023.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

final class ListViewModel {
    private let apiService: APIServiceProtocol
    private let disposeBag = DisposeBag()
    
    let launches = BehaviorRelay<[Launch]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
        
    let navigationTitle: String = "List"
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func fetchLaunches() {
        isLoading.accept(true)
        
        apiService.fetchLaunches()
            .subscribe(
                onSuccess: { [weak self] launches in
                    self?.isLoading.accept(false)
                    self?.launches.accept(launches.sorted { $0.date < $1.date })
                },
                onFailure: { [weak self] error in
                    self?.isLoading.accept(false)
                    print(error.localizedDescription)
                })
            .disposed(by: disposeBag)
    }
}

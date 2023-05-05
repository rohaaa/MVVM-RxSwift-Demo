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
    
    // TODO: error handling
    let error = BehaviorRelay<Error?>(value: nil)
    
    private let currentPage = BehaviorRelay<Int>(value: 1)
    private let isLastPage = BehaviorRelay<Bool>(value: false)
    private let pageSize = 20
        
    let navigationTitle: String = "List"
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func fetchLaunches() {
        guard !isLastPage.value else { return }
        isLoading.accept(true)
        
        let query: [String: Any] = [:]
        let options: [String: Any] = ["limit": pageSize, "page": currentPage.value]
        
        apiService.fetchLaunches(query: query, options: options)
            .subscribe(
                onSuccess: { [weak self] launches in
                    guard let self = self else { return }
                    
                    self.isLoading.accept(false)
                    self.isLastPage.accept(launches.count < self.pageSize)
                    
                    let updatedLaunches = self.launches.value + launches.sorted { $0.date < $1.date }
                    
                    self.launches.accept(updatedLaunches)
                    self.currentPage.accept(self.currentPage.value + 1)
                },
                onFailure: { [weak self] error in
                    self?.isLoading.accept(false)
                    self?.error.accept(error)
                    print(error.localizedDescription)
                })
            .disposed(by: disposeBag)
    }
}

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
    
    let error = BehaviorRelay<AppError?>(value: nil)
    
    private var currentPage = 1
    private var isLastPage = false
    private let pageSize = 20
    
    let navigationTitle: String = "List"
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func fetchLaunches() {
        guard !isLastPage else { return }
        isLoading.accept(true)
        
        let query: [String: Any] = [:]
        let options: [String: Any] = ["limit": pageSize, "page": currentPage]
        
        apiService.fetchLaunches(query: query, options: options)
            .subscribe(
                onSuccess: { [weak self] launches in
                    guard let self = self else { return }
                    
                    self.isLoading.accept(false)
                    self.isLastPage = launches.count < self.pageSize
                    
                    let updatedLaunches = self.launches.value + launches.sorted { $0.date < $1.date }
                    
                    self.launches.accept(updatedLaunches)
                    self.currentPage += 1
                },
                onFailure: { [weak self] error in
                    self?.isLoading.accept(false)
                    if let appError = error as? AppError {
                        self?.error.accept(appError)
                    } else {
                        self?.error.accept(.requestFailed)
                    }
                })
            .disposed(by: disposeBag)
    }
}

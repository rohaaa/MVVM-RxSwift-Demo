//
//  ListViewModelTests.swift
//  MVVM-RxSwift-DemoTests
//
//  Created by Armand Kaguermanov on 03/05/2023.
//

import XCTest
import RxSwift
import RxCocoa
import Moya
@testable import MVVM_RxSwift_Demo

class ListViewModelTests: XCTestCase {
    var sut: ListViewModel!
    var mockAPIService: MockAPIService!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        mockAPIService = MockAPIService()
        sut = ListViewModel(apiService: mockAPIService)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockAPIService = nil
        disposeBag = nil
    }
    
    func testFetchLaunches() {
        let expectation = XCTestExpectation(description: "Launches fetched")
        
        mockAPIService.launches = [
            Launch(id: "1", name: "launch 1", date: "", details: "", links: nil),
            Launch(id: "2", name: "launch 2", date: "", details: "", links: nil)
        ]
        
        sut.launches
            .skip(1)
            .subscribe(onNext: { launches in
                XCTAssertEqual(launches.count, 2)
                XCTAssertEqual(launches[0].id, "1")
                XCTAssertEqual(launches[1].id, "2")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        sut.fetchLaunches()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchLaunches_IsLoading() {
        let isLoadingTrueExpectation = XCTestExpectation(description: "isLoading set to true")
        let isLoadingFalseExpectation = XCTestExpectation(description: "isLoading set to false")
        
        sut.isLoading
            .skip(1)
            .subscribe(onNext: { isLoading in
                if isLoading {
                    isLoadingTrueExpectation.fulfill()
                } else {
                    isLoadingFalseExpectation.fulfill()
                }
            })
            .disposed(by: disposeBag)
        
        sut.fetchLaunches()
        wait(for: [isLoadingTrueExpectation, isLoadingFalseExpectation], timeout: 1.0)
    }
    
    func testFetchLaunches_Pagination() {
        let firstPageExpectation = XCTestExpectation(description: "First page fetched")
        let secondPageExpectation = XCTestExpectation(description: "Second page fetched")
        let pageSize = 20
        
        mockAPIService.launches = Array(repeating: Launch(id: "1", name: "launch 1", date: "", details: "", links: nil), count: pageSize)
        
        sut.launches
            .skip(1)
            .subscribe(onNext: { launches in
                if launches.count == pageSize {
                    firstPageExpectation.fulfill()
                    self.sut.fetchLaunches()
                } else if launches.count == pageSize * 2 {
                    secondPageExpectation.fulfill()
                }
            })
            .disposed(by: disposeBag)
        
        sut.fetchLaunches()
        wait(for: [firstPageExpectation, secondPageExpectation], timeout: 1.0)
    }
    
    func testFetchLaunches_Error() {
        let expectation = XCTestExpectation(description: "Error handled and isLoading set to false")
        
        mockAPIService.error = MoyaError.requestMapping("Error")
        
        sut.error
            .skip(1)
            .subscribe(onNext: { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        sut.fetchLaunches()
        wait(for: [expectation], timeout: 1.0)
    }
}

class MockAPIService: APIServiceProtocol {
    var launches: [Launch] = []
    var error: MoyaError?
    
    func fetchLaunches(query: [String: Any], options: [String: Any]) -> Single<[Launch]> {
        if let error = error {
            return Single.error(error)
        }
        return Single.just(launches)
    }
}

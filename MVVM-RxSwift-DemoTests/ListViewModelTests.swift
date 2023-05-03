//
//  ListViewModelTests.swift
//  MVVM-RxSwift-DemoTests
//
//  Created by Armand Kaguermanov on 03/05/2023.
//

import XCTest
import RxSwift
import RxCocoa
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
}

class MockAPIService: APIServiceProtocol {
    var launches: [Launch] = []
    
    func fetchLaunches() -> Single<[Launch]> {
        return Single.just(launches)
    }
}

//
//  DetailsViewModelTests.swift
//  MVVM-RxSwift-DemoTests
//
//  Created by Armand Kaguermanov on 03/05/2023.
//

import XCTest
@testable import MVVM_RxSwift_Demo

class DetailsViewModelTests: XCTestCase {
    var sut: DetailsViewModel!
    var launch: Launch!
    
    override func setUpWithError() throws {
        super.setUp()
        launch = Launch(id: "1", name: "launch 1", date: "", details: "", links: nil)
        sut = DetailsViewModel(launch: launch)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        launch = nil
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertEqual(sut.navigationTitle, "Details", "")
        XCTAssertEqual(sut.launch.id, launch.id, "")
    }
}

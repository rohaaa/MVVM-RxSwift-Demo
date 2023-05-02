//
//  DetailsViewModel.swift
//  MVVM-RxSwift-Demo
//
//  Created by Armand Kaguermanov on 02/05/2023.
//

import Foundation

final class DetailsViewModel {
    let navigationTitle = "Details"
    let launch: Launch

    init(launch: Launch) {
        self.launch = launch
    }
}

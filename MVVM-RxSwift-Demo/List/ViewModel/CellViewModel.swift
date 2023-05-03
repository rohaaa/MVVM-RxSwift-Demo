//
//  CellViewModel.swift
//  MVVM-RxSwift-Demo
//
//  Created by Armand Kaguermanov on 02/05/2023.
//

import Foundation

struct CellViewModel {
    let imageUrl: String
    let title: String
    let subtitle: String
    
    init(launch: Launch) {
        self.title = launch.name
        self.subtitle = launch.date
        self.imageUrl = launch.links?.patch.small ?? ""
    }
}

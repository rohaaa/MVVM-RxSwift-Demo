//
//  Launch.swift
//  MVVM-RxSwift-Demo
//
//  Created by Armand Kaguermanov on 02/05/2023.
//

import Foundation

struct Launch: Codable {
    let id: String
    let name: String
    let date: String
    let details: String?
    let links: LaunchLinks?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case date = "date_utc"
        case details
        case links
    }
}

struct LaunchLinks: Codable {
    let patch: Patch
}

struct Patch: Codable {
    let small: String?
    let large: String?
}

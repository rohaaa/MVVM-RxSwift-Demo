//
//  AppError.swift
//  MVVM-RxSwift-Demo
//
//  Created by Armand Kaguermanov on 05/05/2023.
//

import Foundation

enum AppError: Error {
    case requestFailed
    case parsingFailed
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .requestFailed:
            return NSLocalizedString("Request failed. Please check your connection and try again.", comment: "")
        case .parsingFailed:
            return NSLocalizedString("Parsing failed. Please contact the app developer.", comment: "")
        }
    }
}

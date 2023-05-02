//
//  SpaceXAPI.swift
//  MVVM-RxSwift-Demo
//
//  Created by Armand Kaguermanov on 02/05/2023.
//

import Foundation
import Moya

enum SpaceXAPI {
    case getLaunches
}

extension SpaceXAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.spacexdata.com/v4")!
    }
    
    var path: String {
        switch self {
        case .getLaunches:
            return "/launches"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getLaunches:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getLaunches:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var sampleData: Data {
        return Data()
    }
}

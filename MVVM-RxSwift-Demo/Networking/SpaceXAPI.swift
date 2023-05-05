//
//  SpaceXAPI.swift
//  MVVM-RxSwift-Demo
//
//  Created by Armand Kaguermanov on 02/05/2023.
//

import Foundation
import Moya

enum SpaceXAPI {
    case getLaunches(query: [String: Any], options: [String: Any])
}

extension SpaceXAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.spacexdata.com/v4")!
    }
    
    var path: String {
        switch self {
        case .getLaunches:
            return "/launches/query"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getLaunches:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getLaunches(let query, let options):
            return .requestParameters(
                parameters: ["query": query,
                             "options": options],
                encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var sampleData: Data {
        return Data()
    }
}

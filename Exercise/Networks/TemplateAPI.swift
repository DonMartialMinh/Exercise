//
//  TemplateAPI.swift
//  Exercise
//
//  Created by Vo Minh Don on 11/15/21.
//

import Foundation
import Alamofire

enum TemplateAPI {
    case template(String)
}

// MARK: - TemplateAPI
extension TemplateAPI: TargetType {
    var params: Parameters {
        get {
            switch self {
            case .template:
                return ["asp_key": "shimapri"]
            }
        }
    }

    var baseUrl: String {
        return "https://api2-6.shimaumaprint.com/postcard/api/shimapri/"
    }

    var path: String {
        switch self {
        case .template(let templateCode):
            return "templates/\(templateCode)"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .template:
            return .get
        }
    }

    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json"]
    }

    var url: URL {
        return URL(string: self.baseUrl + self.path)!
    }

    var encoding: ParameterEncoding {
        switch self {
        case .template:
            return URLEncoding.default
        }
    }
}

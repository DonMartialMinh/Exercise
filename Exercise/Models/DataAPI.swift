//
//  UserAPI.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/20/21.
//

import Foundation
import Alamofire

enum DataAPI {
  case stamps
}

// MARK: - UserAPI
extension DataAPI: TargetType {
  var params: [String : Any] {
    return ["category_id": 4,
            "asp_key": "shimapri",
            "use_type": "n"]
  }

  var baseUrl: String {
    return "https://api2-6.shimaumaprint.com/postcard/api/shimapri/"
  }

  var path: String {
    switch self {
    case .stamps:
      return "stamps"
    }
  }

  var httpMethod: HTTPMethod {
    switch self {
    case .stamps:
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
    case .stamps:
      return URLEncoding.default
    }
  }
}

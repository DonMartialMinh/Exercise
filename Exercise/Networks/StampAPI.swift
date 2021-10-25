//
//  UserAPI.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/20/21.
//

import Foundation
import Alamofire

enum StampAPI {
  case stamps(Int)
  case categories
}

// MARK: - StampAPI
extension StampAPI: TargetType {
  var params: Parameters {
    get {
      switch self {
      case .stamps(let id):
        return ["category_id": id,
                "asp_key": "shimapri",
                "use_type": "n"]
      case .categories:
        return ["asp_key": "shimapri",
                "use_type": "n"]
      }
    }
  }

  var baseUrl: String {
    return "https://api2-6.shimaumaprint.com/postcard/api/shimapri/"
  }

  var path: String {
    switch self {
    case .stamps:
      return "stamps"
    case .categories:
      return "stamps/categories"
    }
  }

  var httpMethod: HTTPMethod {
    switch self {
    case .stamps, .categories:
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
    case .stamps, .categories:
      return URLEncoding.default
    }
  }
}

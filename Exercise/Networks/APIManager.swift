//
//  APIManager.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/20/21.
//

import Foundation
import Alamofire

class APIManager {
  static var shared = APIManager()
  // MARK: - Init
  private init() {}

  // MARK: - Method
  func call<T> (type: TargetType, completionHandler: @escaping (_ result: Result<T?, ​ResponseError​>)->()) where T: Codable {
    AF.request(type.url,
               method: type.httpMethod,
               parameters: type.params,
               encoding: type.encoding,
               headers: type.headers)
      .validate().responseJSON { (data) in
        switch data.result {
        case .success(_):
          let decoder = JSONDecoder()
          if let jsonData = data.data {
            let result = try! decoder.decode(T.self, from: jsonData)
            completionHandler(.success(result))
          }
          break
        case .failure(_):
          let decoder = JSONDecoder()
          if let jsonData = data.data, let error = try? decoder.decode(​ResponseError​.self, from: jsonData) {
            completionHandler(.failure(error))
          }
          break
        }
      }
  }

  func fetchData (completionHandler: @escaping (_ result: Result<StampModel?, ​ResponseError​>)->()) {
    APIManager.shared.call(type: DataAPI.stamps) { (result: Result<StampModel?, ​ResponseError​>) in
      switch result {
      case .success(let results):
        completionHandler(.success(results))
      case .failure(let error):
        completionHandler(.failure(error))
      }
    }
  }
}

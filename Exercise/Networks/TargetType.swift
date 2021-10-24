//
//  TargetType.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/20/21.
//

import Foundation
import Alamofire

protocol TargetType {
  var params: [String : Any] {get}
  var baseUrl: String { get }
  var path: String { get }
  var httpMethod: HTTPMethod { get }
  var headers: HTTPHeaders? { get }
  var url: URL { get }
  var encoding: ParameterEncoding { get }
}

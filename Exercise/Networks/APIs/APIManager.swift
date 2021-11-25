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
    func call<T> (type: TargetType, params: Parameters? = nil, completionHandler: @escaping (_ result: Result<T?, ​ResponseError​>)->()) where T: Codable {
        AF.request(type.url,
                   method: type.httpMethod,
                   parameters: params,
                   encoding: type.encoding,
                   headers: type.headers)
            .validate().responseJSON { (data) in
                switch data.result {
                case .success(_):
                    let decoder = JSONDecoder()
                    if let jsonData = data.data, let statusResponse = try? decoder.decode(StatusResponse.self, from: jsonData){
                        switch statusResponse.status {
                        case 200:
                            let result = try! decoder.decode(T.self, from: jsonData)
                            completionHandler(.success(result))
                        case 400:
                            let error = try! decoder.decode(InvalidRequestError.self, from: jsonData)
                            let responseError = ​ResponseError​()
                            guard let errorMessage = error.errors.first?.message else { return }
                            responseError.errors = errorMessage
                            completionHandler(.failure(responseError))
                        default:
                            let error = try! decoder.decode(​ResponseError​.self, from: jsonData)
                            completionHandler(.failure(error))
                        }
                    }
                case .failure(let error):
                    let responseError = ​ResponseError​()
                    responseError.errors = error.localizedDescription
                    completionHandler(.failure(responseError))
                }
            }
    }
}

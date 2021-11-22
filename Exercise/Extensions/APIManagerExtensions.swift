//
//  APIManagerExtensions.swift
//  Exercise
//
//  Created by Vo Minh Don on 11/4/21.
//

import Foundation

extension APIManager {
    func fetchStamps (id: Int, completionHandler: @escaping (_ result: Result<BaseResponseModel<Stamp>?, ​ResponseError​>)->()) {
        APIManager.shared.call(type: StampAPI.stamps(id), params: StampAPI.stamps(id).params) { (result: Result<BaseResponseModel<Stamp>?, ​ResponseError​>) in
            switch result {
            case .success(let results):
                completionHandler(.success(results))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    func fetchCategories (completionHandler: @escaping (_ result: Result<BaseResponseModel<Category>?, ​ResponseError​>)->()) {
        APIManager.shared.call(type: StampAPI.categories, params: StampAPI.categories.params) { (result: Result<BaseResponseModel<Category>?, ​ResponseError​>) in
            switch result {
            case .success(let results):
                completionHandler(.success(results))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    func fetchTemplates (code: String, completionHandler: @escaping (_ result: Result<BaseResponseModel<Template>?, ​ResponseError​>)->()) {
        APIManager.shared.call(type: TemplateAPI.template(code), params: TemplateAPI.template(code).params) { (result: Result<BaseResponseModel<Template>?, ​ResponseError​>) in
            switch result {
            case .success(let results):
                completionHandler(.success(results))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}

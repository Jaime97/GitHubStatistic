//
//  Observable+Decode.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 09/06/2021.
//

import Foundation
import RxSwift

extension Observable where Element == (HTTPURLResponse, Data) {
    internal func expectingObject<T : Codable>(ofType type: T.Type) -> Observable<GitApiResult<T, GitApiError>>{
        return self.map{ (httpURLResponse, data) -> GitApiResult<T, GitApiError> in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(formatter)
            switch httpURLResponse.statusCode{
            case 200 ... 299:
                let apiResult: GitApiResult<T, GitApiError>
                do {
                    let object = try decoder.decode(type, from: data)
                    apiResult = .success(object)
                }
                catch {
                    apiResult = .failure(GitApiError(message: "Failed to decode data."))
                }
                return apiResult
            default:
                let apiErrorMessage: GitApiError
                do{
                    apiErrorMessage = try decoder.decode(GitApiError.self, from: data)
                } catch _ {
                    apiErrorMessage = GitApiError(message: "Failed to decode data.")
                }
                return .failure(apiErrorMessage)
            }
        }
    }
}

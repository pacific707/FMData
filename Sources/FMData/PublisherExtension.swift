

import Foundation
import Combine
import FMRest

extension Publisher {
    
    func dataAPIResponse<T>() -> AnyPublisher<T, FMRest.APIError> where Self.Output == FMRest.Response<T>{
        
        tryMap {
            guard let response = $0.response else {
                throw FMRest.APIError.responseError(message: "Response invalid")
            }
            return response
        }
        .mapError { error -> FMRest.APIError in
            return error as? FMRest.APIError ?? FMRest.APIError.unknown(error: error)
        }
        .eraseToAnyPublisher()

    }
}


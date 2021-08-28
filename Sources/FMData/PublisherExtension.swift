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

extension Publisher {
    
    public func returnAs<R>(_ record: R.Type) -> AnyPublisher<DataAPI.RecordResponse<R, FMRest.EmptyResponse>, FMRest.APIError> where Self.Output == DataAPI.RecordResponse<R, FMRest.EmptyResponse> {
        map {
            $0 as DataAPI.RecordResponse<R, FMRest.EmptyResponse>
        }
        .mapError { error -> FMRest.APIError in
            return error as? FMRest.APIError ?? FMRest.APIError.unknown(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    public func returnAs<R,P>(_ record: R.Type, _ portal: P.Type) -> AnyPublisher<DataAPI.RecordResponse<R, P>, FMRest.APIError> where Self.Output == DataAPI.RecordResponse<R, P> {
        
        map {
            $0 as DataAPI.RecordResponse<R, P>
        }
        .mapError { error -> FMRest.APIError in
            return error as? FMRest.APIError ?? FMRest.APIError.unknown(error: error)
        }
        .eraseToAnyPublisher()

    }
}



import Foundation
import Combine
import FMRest

extension DataAPI.Server {
    
    public func getProductInfo() -> AnyPublisher<ProductInfo, FMRest.APIError> {

        let requestContainer = DataAPI.createRequest(server: self, endpoint: DataAPI.Endpoint.productInfo)
        
        switch requestContainer {
        case .success(let request):
            return FMRest.Agent.run(request)
                .dataAPIResponse()
                .map(\ProductInfoContainer.productInfo)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail<ProductInfo, FMRest.APIError>(error: error).eraseToAnyPublisher()
        }
        
    }
    
    public func getDatabaseNames(credentials: DataAPI.Credentials) -> AnyPublisher<DataAPI.Database.DatabaseListResponse, FMRest.APIError> {

        let requestContainer = DataAPI.createAuthRequest(credentials: credentials, server: self, endpoint: .databaseNames, body: nil as Data?)
        
        switch requestContainer {
        case .success(let request):
            return FMRest.Agent.run(request)
                .dataAPIResponse()
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail<DataAPI.Database.DatabaseListResponse, FMRest.APIError>(error: error)
                .eraseToAnyPublisher()
        }
            
    }
    
    public func validateSession(credentials: DataAPI.Credentials) -> AnyPublisher<FMRest.EmptyResponse, FMRest.APIError>  {
        let requestWrapper = DataAPI.createRequest(credentials: credentials, server: self, endpoint: .validate)
        
        switch requestWrapper {
        case .success(let request):
            return FMRest.Agent.run(request)
                .dataAPIResponse()
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail<FMRest.EmptyResponse, FMRest.APIError>(error: error).eraseToAnyPublisher()
        }
        
    }
    
}

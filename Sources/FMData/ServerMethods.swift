import Foundation
import Combine
import FMRest

extension DataAPI.Server {
    
    public func getProductInfo() -> AnyPublisher<ProductInfo, FMRest.APIError> {

        let request = DataAPI.createRequest(server: self, endpoint: DataAPI.Endpoint.productInfo)
        
        return FMRest.Agent.run(request, config: self.config)
            .dataAPIResponse()
            .map(\ProductInfoContainer.productInfo)
            .eraseToAnyPublisher()
        
    }
    
    public func getDatabaseNames(credentials: DataAPI.Credentials) -> AnyPublisher<DataAPI.Database.DatabaseListResponse, FMRest.APIError> {

        do {
            let request = try DataAPI.createAuthRequest(credentials: credentials, server: self, endpoint: .databaseNames, body: nil as Data?)
            
            return FMRest.Agent.run(request, config: self.config)
                .dataAPIResponse()
                .eraseToAnyPublisher()
        } catch {
            return Fail<DataAPI.Database.DatabaseListResponse, FMRest.APIError>(error: error as! FMRest.APIError)
                .eraseToAnyPublisher()
        }
            
    }
    
    public func validateSession(credentials: DataAPI.Credentials) -> AnyPublisher<FMRest.EmptyResponse, FMRest.APIError>  {
        
        do {
            let request = try DataAPI.createRequest(credentials: credentials, server: self, endpoint: .validate)
            return FMRest.Agent.run(request, config: self.config)
                .dataAPIResponse()
                .eraseToAnyPublisher()
        } catch {
            return Fail<FMRest.EmptyResponse, FMRest.APIError>(error: error as! FMRest.APIError).eraseToAnyPublisher()
        }
        
    }
    
}

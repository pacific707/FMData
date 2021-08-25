import Foundation
import Combine
import FMRest

extension DataAPI.Database {
    
    public func login(credentials: DataAPI.Credentials, dataSourceCredentials: DataAPI.FMDataSourceAuth? = nil) -> AnyPublisher<DataAPI.Credentials, FMRest.APIError> {
        
        let requestWrapper = DataAPI.createAuthRequest(credentials: credentials, server: self.server, endpoint: .auth(database: self.name), body: dataSourceCredentials)
   
        switch requestWrapper {
        case .success(let request):
            return FMRest.Agent.run(request)
                .map { $0 as FMRest.Response<AccessToken> }
//                .receive(on: DispatchQueue.main)
                .tryMap {
                    guard let token = $0.authToken ?? $0.response?.token else {
                        throw FMRest.APIError.responseError(message: "Response missing")
                    }
                    let updatedCredentials: DataAPI.Credentials = .token(token)
                    self.objectWillChange.send()
                    self.credentials = updatedCredentials
                    return updatedCredentials
                }
                .mapError { error -> FMRest.APIError in
                    return error as? FMRest.APIError ?? FMRest.APIError.unknown(error: error)
                }
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail<DataAPI.Credentials, FMRest.APIError>(error: error).eraseToAnyPublisher()
        }
        
    }
    
    public func logOut() -> AnyPublisher<FMRest.EmptyResponse, FMRest.APIError> {
        
        guard case .token(let token) = self.credentials else {
            return Fail<FMRest.EmptyResponse, FMRest.APIError>(error: .authTypeError(message: "No token to deauthenticate")).eraseToAnyPublisher()
        }
        let request = DataAPI.createRequest(credentials: self.credentials, server: self.server, endpoint: .deAuth(database: self.name, token: token))
         
        switch request {
        case .success(let req):
            return FMRest.Agent.run(req)
                .dataAPIResponse()
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail<FMRest.EmptyResponse, FMRest.APIError>(error: error).eraseToAnyPublisher()
        }
        
    }
    
    public func getLayoutNames() -> AnyPublisher<[LayoutListItem], FMRest.APIError> {

        let requestWrapper = DataAPI.createRequest(credentials: self.credentials, server: self.server, endpoint: .layoutNames(database: self.name))
        switch requestWrapper {
        case .success(let request):
            return FMRest.Agent.run(request)
                .dataAPIResponse()
                .map(\LayoutContainer.layouts)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail<[LayoutListItem], FMRest.APIError>(error: error).eraseToAnyPublisher()
        }
        
    }
    
    public func getScriptNames() -> AnyPublisher<[ScriptItem], FMRest.APIError> {
        
        let requestWrapper = DataAPI.createRequest(credentials: self.credentials, server: self.server, endpoint: .scriptNames(database: self.name))
        switch requestWrapper {
        case .success(let request):
            return FMRest.Agent.run(request)
                .dataAPIResponse()
                .map(\DataAPI.Database.ScriptContainer.scripts)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail<[ScriptItem], FMRest.APIError>(error: error).eraseToAnyPublisher()
        }
        
    }

    
    public func setGlobalFields(globalFields: [String: String]) -> AnyPublisher<FMRest.EmptyResponse, FMRest.APIError> {
        
        let requestWrapper = DataAPI.createRequest(credentials: self.credentials, server: self.server, endpoint: .setGlobalFields(database: self.name), body: globalFields)
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

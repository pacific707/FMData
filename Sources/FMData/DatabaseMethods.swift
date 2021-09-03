import Foundation
import Combine
import FMRest

extension DataAPI.Database {
    
    public func login(credentials: DataAPI.Credentials, dataSourceCredentials: DataAPI.FMDataSourceAuth? = nil) -> AnyPublisher<DataAPI.Credentials, FMRest.APIError> {
        
        guard let server = self.server else {
            return Fail<DataAPI.Credentials, FMRest.APIError>(error: .apiError(message: "no attached server")).eraseToAnyPublisher()
        }
        
        do {
            let request = try DataAPI.createAuthRequest(credentials: credentials, server: server, endpoint: .auth(database: self.name), body: dataSourceCredentials)
            
            return FMRest.Agent.run(request, config: server.config)
                .map { $0 as FMRest.Response<AccessToken> }
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
        } catch {
            return Fail<DataAPI.Credentials, FMRest.APIError>(error: error as! FMRest.APIError).eraseToAnyPublisher()
        }
        
    }
    
    public func logOut() -> AnyPublisher<FMRest.EmptyResponse, FMRest.APIError> {
        
        guard case .token(let token) = self.credentials else {
            return Fail<FMRest.EmptyResponse, FMRest.APIError>(error: .authTypeError(message: "No token to deauthenticate")).eraseToAnyPublisher()
        }
        guard let server = self.server else {
            return Fail<FMRest.EmptyResponse, FMRest.APIError>(error: .apiError(message: "no attached server")).eraseToAnyPublisher()
        }
        
        do {
            let request = try DataAPI.createRequest(credentials: self.credentials, server: server, endpoint: .deAuth(database: self.name, token: token))
            return FMRest.Agent.run(request, config: server.config)
                .dataAPIResponse()
                .eraseToAnyPublisher()
        } catch {
            return Fail<FMRest.EmptyResponse, FMRest.APIError>(error: error as! FMRest.APIError)
                .eraseToAnyPublisher()
        }
        
    }
    
    public func getLayoutNames() -> AnyPublisher<[LayoutListItem], FMRest.APIError> {

        guard let server = self.server else {
            return Fail<[LayoutListItem], FMRest.APIError>(error: .apiError(message: "no attached server")).eraseToAnyPublisher()
        }
        
        do {
            let request = try DataAPI.createRequest(credentials: self.credentials, server: server, endpoint: .layoutNames(database: self.name))
            return FMRest.Agent.run(request, config: server.config)
                .dataAPIResponse()
                .map(\LayoutContainer.layouts)
                .eraseToAnyPublisher()
        } catch {
            return Fail<[LayoutListItem], FMRest.APIError>(error: error as! FMRest.APIError).eraseToAnyPublisher()
        }
        
    }
    
    public func getScriptNames() -> AnyPublisher<[ScriptItem], FMRest.APIError> {
        
        guard let server = self.server else {
            return Fail<[ScriptItem], FMRest.APIError>(error: .apiError(message: "no attached server")).eraseToAnyPublisher()
        }
        
        do {
            let request = try DataAPI.createRequest(credentials: self.credentials, server: server, endpoint: .scriptNames(database: self.name))
            return FMRest.Agent.run(request, config: server.config)
                .dataAPIResponse()
                .map(\DataAPI.Database.ScriptContainer.scripts)
                .eraseToAnyPublisher()
        } catch {
            return Fail<[ScriptItem], FMRest.APIError>(error: error as! FMRest.APIError).eraseToAnyPublisher()
        }
       
    }

    
    public func setGlobalFields(globalFields: [String: String]) -> AnyPublisher<FMRest.EmptyResponse, FMRest.APIError> {
        
        guard let server = self.server else {
            return Fail<FMRest.EmptyResponse, FMRest.APIError>(error: .apiError(message: "no attached server")).eraseToAnyPublisher()
        }
        do {
            
            let request = try DataAPI.createRequest(credentials: self.credentials, server: server, endpoint: .setGlobalFields(database: self.name), body: globalFields)
            return FMRest.Agent.run(request, config: server.config)
                .dataAPIResponse()
                .eraseToAnyPublisher()
        } catch {
            return Fail<FMRest.EmptyResponse, FMRest.APIError>(error: error as! FMRest.APIError).eraseToAnyPublisher()
        }
        
    }
    
}

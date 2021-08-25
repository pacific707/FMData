import Foundation
import FMRest

extension DataAPI {
    
    static func createRequest(credentials: Credentials, server: Server?, endpoint: Endpoint) -> Result<URLRequest, FMRest.APIError> {
        self.createBaseRequest(credentials: credentials, server: server, endpoint: endpoint, queryParameters: [], body: nil as Data?)
    }
    
    static func createRequest(credentials: Credentials, server: Server?, endpoint: Endpoint, queryParameters: [URLQueryItem] = []) -> Result<URLRequest, FMRest.APIError> {
        self.createBaseRequest(credentials: credentials, server: server, endpoint: endpoint, queryParameters: queryParameters, body: nil as Data?)
    }
    
    static func createRequest<T: Encodable>(credentials: Credentials, server: Server?, endpoint: Endpoint, queryParameters: [URLQueryItem], body: T?) -> Result<URLRequest, FMRest.APIError> {
        self.createBaseRequest(credentials: credentials, server: server, endpoint: endpoint, queryParameters: queryParameters, body: body)
    }
    
    static func createRequest<T: Encodable>(credentials: Credentials, server: Server?, endpoint: Endpoint, body: T?) -> Result<URLRequest, FMRest.APIError> {
        self.createBaseRequest(credentials: credentials, server: server, endpoint: endpoint, queryParameters: [], body: body)
    }
    
    static func createRequest(server: Server?, endpoint: Endpoint) -> Result<URLRequest, FMRest.APIError> {
        guard let requestServer = server else {
            return.failure(FMRest.APIError.apiError(message: "database is not connected to a server"))
        }
        return .success(FMRest.createRequest(credentials: Credentials.invalid, host: requestServer.host, config: requestServer.config, method: endpoint.method, endpoint: endpoint))
    }
    
    static func createBaseRequest<T: Encodable>(credentials: Credentials, server: Server?, endpoint: Endpoint, queryParameters: [URLQueryItem], body: T?) -> Result<URLRequest, FMRest.APIError> {
        
        guard case .token(_) = credentials else {
            return.failure(FMRest.APIError.apiError(message: "Credentials do not contain a token"))
        }
        guard let requestServer = server else {
            return.failure(FMRest.APIError.apiError(message: "database is not connected to a server"))
        }
        
        let requestWrapper = FMRest.createRequest(credentials: credentials, host: requestServer.host, config: requestServer.config, method: endpoint.method, endpoint: endpoint, data: body)
        switch requestWrapper {
        case .success(let request):
            return .success(request)
        case .failure(let error):
            return .failure(error)
        }
        
    }
    
    static func createUploadRequest(credentials: Credentials, server: Server?, endpoint: Endpoint, queryParameters: [URLQueryItem], data: FMRest.ContainerFile) -> Result<URLRequest, FMRest.APIError> {
        
        guard case .token(_) = credentials else {
            return.failure(FMRest.APIError.apiError(message: "Credentials do not contain a token"))
        }
        guard let requestServer = server else {
            return.failure(FMRest.APIError.apiError(message: "database is not connected to a server"))
        }
        return .success(FMRest.createRequest(credentials: credentials, host: requestServer.host, config: requestServer.config, method: endpoint.method, endpoint: endpoint, data: data))
        
    }
    
    static func createAuthRequest<T: Encodable>(credentials: Credentials, server: Server?, endpoint: Endpoint, body: T?) -> Result<URLRequest, FMRest.APIError> {
        
        guard let requestServer = server else {
            return .failure(.apiError(message: "database is not connected to a server"))
        }
        
        switch credentials {
        case .token(_):
            return .failure(.authTypeError(message: "Already authenticated with token"))
        case .invalid:
            return .failure(.authTypeError(message: "Credentials set to invalid"))
        default:
            let requestWrapper: Result<URLRequest, FMRest.APIError>
            if let httpBody = body {
                requestWrapper = FMRest.createRequest(credentials: credentials, host: requestServer.host, config: requestServer.config, method: endpoint.method, endpoint: endpoint, data: httpBody)
            } else {
                return .success( FMRest.createRequest(credentials: credentials, host: requestServer.host, config: requestServer.config, method: endpoint.method, endpoint: endpoint) )
            }
            switch requestWrapper {
            case .success(let request):
                return .success(request)
            case .failure(let error):
                return .failure(error)
            }
        }
     
    }
}

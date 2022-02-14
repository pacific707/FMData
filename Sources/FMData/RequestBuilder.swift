import Foundation
import FMRest

extension DataAPI {
    
    static func createRequest(credentials: Credentials, server: Server, endpoint: Endpoint) throws -> URLRequest {
        try self.createBaseRequest(credentials: credentials, server: server, endpoint: endpoint, queryParameters: [], body: nil as Data?)
    }
    
    static func createRequest(credentials: Credentials, server: Server, endpoint: Endpoint, queryParameters: [URLQueryItem] = []) throws -> URLRequest {
        try self.createBaseRequest(credentials: credentials, server: server, endpoint: endpoint, queryParameters: queryParameters, body: nil as Data?)
    }
    
    static func createRequest<T: Encodable>(credentials: Credentials, server: Server, endpoint: Endpoint, queryParameters: [URLQueryItem], body: T?) throws -> URLRequest {
        try self.createBaseRequest(credentials: credentials, server: server, endpoint: endpoint, queryParameters: queryParameters, body: body)
    }
    
    static func createRequest<T: Encodable>(credentials: Credentials, server: Server, endpoint: Endpoint, body: T?) throws -> URLRequest {
        try self.createBaseRequest(credentials: credentials, server: server, endpoint: endpoint, queryParameters: [], body: body)
    }
    
    static func createRequest(server: Server, endpoint: Endpoint) -> URLRequest {
        return FMRest.createRequest(credentials: Credentials.invalid, host: server.host, config: server.config, method: endpoint.method, endpoint: endpoint)
    }
    
    static func createBaseRequest<T: Encodable>(credentials: Credentials, server: Server, endpoint: Endpoint, queryParameters: [URLQueryItem], body: T?) throws -> URLRequest {
        
        guard case .token(_) = credentials else {
            throw FMRest.APIError.apiError(message: "Credentials do not contain a token")
        }
//        guard let requestServer = server else {
//            throw FMRest.APIError.apiError(message: "database is not connected to a server")
//        }
//        
        if let httpBody = body {
            return try FMRest.createRequest(credentials: credentials, host: server.host, config: server.config, method: endpoint.method, endpoint: endpoint, data: httpBody)
        } else {
            return FMRest.createRequest(credentials: credentials, host: server.host, config: server.config, method: endpoint.method, endpoint: endpoint, queryParameters: queryParameters)
        }
        
    }
    
    static func createUploadRequest(credentials: Credentials, server: Server, endpoint: Endpoint, queryParameters: [URLQueryItem], data: FMRest.ContainerFile) throws -> URLRequest {
        
        switch credentials {
        case .invalid:
            throw FMRest.APIError.authTypeError(message: "Credentials set to invalid")
        default:
            return FMRest.createRequest(credentials: credentials, host: server.host, config: server.config, method: endpoint.method, endpoint: endpoint, data: data)
        }

    }
    
    static func createAuthRequest<T: Encodable>(credentials: Credentials, server: Server, endpoint: Endpoint, body: T?) throws -> URLRequest {
 
        
        switch credentials {
        case .token(_):
            throw FMRest.APIError.authTypeError(message: "Already authenticated with token")
        case .invalid:
            throw FMRest.APIError.authTypeError(message: "Credentials set to invalid")
        default:
            
            if let httpBody = body {
                return try FMRest.createRequest(credentials: credentials, host: server.host, config: server.config, method: endpoint.method, endpoint: endpoint, data: httpBody)
            } else {
                return FMRest.createRequest(credentials: credentials, host: server.host, config: server.config, method: endpoint.method, endpoint: endpoint)
            }
            
        }
     
    }
}

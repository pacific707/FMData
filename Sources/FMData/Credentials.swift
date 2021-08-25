import Foundation
import FMRest

extension DataAPI {
    
    public enum Credentials: FMRestCredentials {
        
        case clarisId(_ fmid: String)
        case basic(_ userPassBase64: String)
        case oAuth(_ requestId: String, _ identifier: String)
        case token(_ sessionToken: String)
        case invalid
        
        public init(user: String, password: String) {
            
            let loginString = "\(user):\(password)"
            let loginData = loginString.data(using: String.Encoding.utf8)
            let base64 = loginData!.base64EncodedString()
            
            self = .basic(base64)
        }
        
        public init(oAuthId: String, oAuthIdentifier: String) {
            self = .oAuth(oAuthId, oAuthIdentifier)
        }
        
        public init(clarisId: String) {
            self = .clarisId(clarisId)
        }
        
        public init(token: String) {
            self = .token(token)
        }
        
        public var headers: [FMRest.Header] {
            switch self {
            
            case .clarisId(let clarisId):
                return [FMRest.Header(value: "FMID \(clarisId)", field: "Authorization")]
            case .basic(let userPass64):
                return [
                    FMRest.Header(value: "Basic \(userPass64)", field: "Authorization"),
                    FMRest.Header(value: "application/json", field: "Content-Type")
                ]
            case .oAuth(let requestId, let identifier):
                return [
                    FMRest.Header(value: requestId, field: "X-FM-Data-OAuth-Request-Id"),
                    FMRest.Header(value: identifier, field: "X-FM-Data-OAuth-Identifier")
                ]
            case .token(let token):
                return [FMRest.Header(value: "Bearer \(token)", field: "Authorization")]
            case .invalid:
                return []
            }
        }
    }
    
    public struct FMDataSourceAuth: Encodable {
        
        public let fmDataSource: [Credentials]
        
        public struct Credentials: Encodable {
            
            public let database: String
            public let credentials: AuthType
            
            public init(database: String, credentials: AuthType) {
                self.database = database
                self.credentials = credentials
            }
            
            public enum CodingKeys: String, CodingKey {
                case database
                case username
                case password
                case oAuthRequestId
                case oAuthIdentifier
            }
            
            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(database, forKey: .database)
                switch credentials {
                case .basic(user: let user, password: let pass):
                    try container.encode(user, forKey: .username)
                    try container.encode(pass, forKey: .password)
                case .oAuth(requestId: let requestId, identifier: let identifier):
                    try container.encode(requestId, forKey: .oAuthRequestId)
                    try container.encode(identifier, forKey: .oAuthIdentifier)
                }
            }
            
            public enum AuthType {
                
                case basic(user: String, password: String)
                case oAuth(requestId: String, identifier: String)
                
            }
            
        }
        
    }
    
}

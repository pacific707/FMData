import Foundation
import FMRest

public enum DataAPI {
    
    public class Server: FMRestServer, ObservableObject {
        
        public let host: String
        public var databases: Set<Database>
        public var config: FMRestConfig

        public init(host: String, databases: Set<Database> = [], config: FMRestConfig = Config()) {
            self.host = host
            self.databases = databases
            self.config = config
        }

        public func addDatabase(_ name: String) -> Database {
            let newDatabase = Database(name: name, server: self)
            databases.insert(newDatabase)
            return newDatabase
        }
        
    }
    
}

extension DataAPI.Server {
    
    public struct Config: FMRestConfig {
        public var version: String
        public var scheme: String
        public var rootPath: String
        public var decoder: JSONDecoder
        public var options: FMRest.ServerOptions
        
        public init(version: String = "/vLatest", scheme: String = "https", rootPath: String = "/fmi/data", decoder: JSONDecoder = JSONDecoder(), options: FMRest.ServerOptions = FMRest.ServerOptions()) {
            self.version = version
            self.scheme = scheme
            self.rootPath = rootPath
            self.decoder = decoder
            self.options = options
        }
        
    }
    
}

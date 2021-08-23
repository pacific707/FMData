import Foundation

extension DataAPI {
    
    public struct Layout {
        public let name: String
        public var database: Database?
        public var metadata: LayoutMetaData?
        
        public init(name: String, database: Database) {
            self.name = name
            self.database = database
        }
        
        public init(name: String) {
            self.name = name
            self.database = nil
        }
    }

}

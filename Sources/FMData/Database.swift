import Foundation
import Combine


extension DataAPI {
    
    public class Database: ObservableObject {
        
        public let name: String
        public var server: Server?
        @Published public var credentials: Credentials
        @Published public var layoutList: [LayoutListItem]
        @Published public var scriptList: [ScriptItem]
        
        public init(name: String, server: Server, credentials: Credentials = .invalid, layoutList: [LayoutListItem] = [], scriptList: [ScriptItem] = []) {
            self.name = name
            self.credentials = credentials
            self.layoutList = layoutList
            self.server = server
            self.scriptList = scriptList
        }
        
        public func addLayout(_ layoutKey: LayoutKey) -> Layout {
            let newLayout =  Layout(name: layoutKey.layoutName, database: self)
            let layoutItem = LayoutListItem.layout(layout: newLayout)
            layoutList.append(layoutItem)
            return newLayout
        }
        
        public func connectLayouts(_ layoutItems: [LayoutListItem]) -> [LayoutListItem] {
            return layoutItems.map {
                switch $0 {
                case .layout(layout: let layout):
                    return .layout(layout: Layout(name: layout.name, database: self))
                case .folder(name: let name, layouts: let layouts):
                    return .folder(name: name, layouts: connectLayouts(layouts))
                }
            }
        }

    }
    
}

extension DataAPI.Database: Hashable, Comparable {
    
    public static func < (lhs: DataAPI.Database, rhs: DataAPI.Database) -> Bool {
        lhs.name < rhs.name
    }
    
    public static func == (lhs: DataAPI.Database, rhs: DataAPI.Database) -> Bool {
        lhs.name == rhs.name
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
}

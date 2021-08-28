import Foundation

extension DataAPI {

    public struct ScriptResponse: Decodable {
        public let scriptResult: String?
        public let scriptError: String?
        public let scriptErrorPreRequest: String?
        public let scriptResultPreRequest: String?
        public let scriptResultPreSort: String?
        public let scriptErrorPreSort: String?
        
        public enum CodingKeys: String, CodingKey {
            case scriptResult
            case scriptError
            case scriptErrorPreRequest = "scriptError.prerequest"
            case scriptResultPreRequest = "scriptResult.prerequest"
            case scriptResultPreSort = "scriptResult.presort"
            case scriptErrorPreSort = "scriptError.presort"
        }
    }
    
    public struct RecordResponse<R: Decodable, P:Decodable>: Decodable {
        
        public let data: [Record<R>]
        public let dataInfo: DataInfo
        public let scriptResponse: ScriptResponse?
        
        public struct Record<R: Decodable>: Decodable {
            public let fieldData: R
            public let portalData: P?
            public let modId: String
            public let recordId: String
            public let portalDataInfo: [PortalDataInfo]?
            
            public enum CodingKeys: String, CodingKey {
                case fieldData
                case portalData
                case modId
                case recordId
                case portalDataInfo
            }
            
        }
        
        public enum CodingKeys: String, CodingKey {
            case data
            case dataInfo
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.data = try container.decode([Record<R>].self, forKey: .data)
            self.dataInfo = try container.decode(DataInfo.self, forKey: .dataInfo)
            self.scriptResponse = try ScriptResponse(from: decoder)
        }
        
        public struct DataInfo: Decodable {
            
            public let database: String
            public let layout: String
            public let table: String
            public let totalRecordCount: Int
            public let foundCount: Int
            public let returnedCount: Int
            
        }
        
        public struct PortalDataInfo: Decodable {
            
            public let database: String
            public let table: String
            public let foundCount: Int
            public let returnedCount: Int
            
        }
        
    }
    
    public struct CreateResponse: Decodable {
        public let recordId: String
        public let modId: String
        public let scriptResponse: ScriptResponse?
        
        public enum CodingKeys: String, CodingKey {
            case recordId
            case modId
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.recordId = try container.decode(String.self, forKey: .recordId)
            self.modId = try container.decode(String.self, forKey: .modId)
            self.scriptResponse = try ScriptResponse(from: decoder)
        }
    }
    
    public struct EditRecordResponse: Decodable {
        public let modId: String
        public let newPortalRecordInfo: CreatedPortalRecordInfo?
        public let scriptResponse: ScriptResponse?
        
        enum CodingKeys: String, CodingKey {
            case modId
            case newPortalRecordInfo
        }
        
        public struct CreatedPortalRecordInfo: Decodable {
            public let tableName: String
            public let recordId: String
            public let modId: String
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.modId = try container.decode(String.self, forKey: .modId)
            self.newPortalRecordInfo = try container.decodeIfPresent(CreatedPortalRecordInfo.self, forKey: .newPortalRecordInfo)
            self.scriptResponse = try ScriptResponse(from: decoder)
        }
    }
    

}


extension DataAPI.Server {
    
    public struct ProductInfo: Decodable {
        public let buildDate: String
        public let name: String
        public let version: String
        public let dateFormat: String
        public let timeFormat: String
        public let timeStampFormat: String
    }
    
    public struct ProductInfoContainer: Decodable {
        public let productInfo: ProductInfo
    }
    
}

extension DataAPI.Database {
    
    public struct DatabaseListResponse: Decodable {
        
        public let databases: [DatabaseName]
        
        public struct DatabaseName: Decodable {
            public let name: String
        }
        
    }
    
    public struct AccessToken: Decodable {
        public var token: String?
    }
    
    public struct ScriptContainer: Decodable {
        public let scripts: [ScriptItem]
    }
    
    public enum ScriptItem: Decodable {
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let name = try container.decode(String.self, forKey: .name)
            if let scriptFolder = try container.decodeIfPresent([ScriptItem].self, forKey: .folderScriptNames) {
                self = .folder(name, scripts: scriptFolder)
            } else {
                self = .script(name)
            }
        }
        
        case script(_ name: String)
        case folder(_ name: String, scripts: [ScriptItem])
        
        public enum CodingKeys: CodingKey {
            case name
            case folderScriptNames
        }
        
        public var name: String {
            switch self {
            case .script(let name):
                return name
            case .folder(let name, scripts: _):
                return name
            }
        }
        
    }
    
    public struct LayoutContainer: Decodable {
        public let layouts: [LayoutListItem]
    }
    
    public enum LayoutListItem: Decodable {
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let name = try container.decode(String.self, forKey: .name)
            if let folderItems = try container.decodeIfPresent([LayoutListItem].self, forKey: .folderLayoutNames) {
                self = .folder(name: name, layouts: folderItems)
            } else {
                self = .layout(layout: DataAPI.Layout(name: name))
            }
        }
        
        case layout(layout: DataAPI.Layout)
        case folder(name: String, layouts: [LayoutListItem])
        
        public enum CodingKeys: CodingKey {
            case name
            case folderLayoutNames
        }
        
        public var name: String {
            switch self {
            case .layout(layout: let layout):
                return layout.name
            case .folder(name: let name, layouts: _):
                return name
            }
        }
    }
}

extension DataAPI.Layout {
    
    public struct LayoutMetaData: Decodable {
        
        public let fieldMetaData: [FieldMetaData]
        public let portalMetaData: [String: [FieldMetaData]]
        public let valueLists: [ValueLists]?
        
        public struct FieldMetaData: Decodable {
            public let name: String
            public let type: FieldType
            public let displayType: DisplayType?
            public let result: CalcResult
            public let global: Bool
            public let autoEnter: Bool
            public let fourDigitYear: Bool
            public let maxRepeat: Int
            public let maxCharacters: Int?
            public let notEmpty: Bool
            public let numeric: Bool
            public let repetitions: Int?
            public let timeOfDay: Bool
            public let valueList: String?
            
            public enum FieldType: String, Decodable {
                case normal
                case calculation
                case summary
            }
            
            public enum DisplayType: String, Decodable {
                case editText
                case popupList
                case popupMenu
                case checkBox
                case radioButtons
                case selectionList
                case calendar
                case secureText
            }
            
            public enum CalcResult: String, Decodable {
                case text
                case number
                case date
                case time
                case timeStamp
                case container
                
            }
            
        }
        
        public struct ValueLists: Decodable {
            public let name: String
            public let type: String
            public let values: [Value]
            
            public struct Value: Decodable {
                public let value: String
                public let displayValue: String
            }
        }
        
    }
   
}

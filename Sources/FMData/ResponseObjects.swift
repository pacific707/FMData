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
            public let modId: Int
            public let recordId: Int
            public let portalDataInfo: [PortalDataInfo]?
            
            public enum CodingKeys: String, CodingKey {
                case fieldData
                case portalData
                case modId
                case recordId
                case portalDataInfo
            }
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.fieldData = try container.decode(R.self, forKey: .fieldData)
                self.portalData = try container.decodeIfPresent(P.self, forKey: .portalData)
                self.portalDataInfo = try container.decodeIfPresent([PortalDataInfo].self, forKey: .portalDataInfo)
                let recordIdString = try container.decode(String.self, forKey: .recordId)
                let modIdString = try container.decode(String.self, forKey: .modId)
                guard let recordIdInt = Int(recordIdString) else {
                    let context = DecodingError.Context(codingPath: container.codingPath + [CodingKeys.recordId], debugDescription: "Error setting recordId to Int")
                    throw DecodingError.dataCorrupted(context)
                }
                guard let modIdInt = Int(modIdString) else {
                    let context = DecodingError.Context(codingPath: container.codingPath + [CodingKeys.modId], debugDescription: "Error setting modId to Int")
                    throw DecodingError.dataCorrupted(context)
                }
                self.recordId = recordIdInt
                self.modId = modIdInt
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
        public let recordId: Int
        public let modId: Int
        public let scriptResponse: ScriptResponse?
        
        public enum CodingKeys: String, CodingKey {
            case recordId
            case modId
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let recordIdString = try container.decode(String.self, forKey: .recordId)
            let modIdString = try container.decode(String.self, forKey: .modId)
            guard let recordIdInt = Int(recordIdString) else {
                let context = DecodingError.Context(codingPath: container.codingPath + [CodingKeys.recordId], debugDescription: "Error setting recordId to Int")
                throw DecodingError.dataCorrupted(context)
            }
            guard let modIdInt = Int(modIdString) else {
                let context = DecodingError.Context(codingPath: container.codingPath + [CodingKeys.modId], debugDescription: "Error setting modId to Int")
                throw DecodingError.dataCorrupted(context)
            }
            self.recordId = recordIdInt
            self.modId = modIdInt
            self.scriptResponse = try ScriptResponse(from: decoder)
        }
    }
    
    public struct EditRecordResponse: Decodable {
        public let modId: Int
        public let newPortalRecordInfo: CreatedPortalRecordInfo?
        public let scriptResponse: ScriptResponse?
        
        enum CodingKeys: String, CodingKey {
            case modId
            case newPortalRecordInfo
        }
        
        public struct CreatedPortalRecordInfo: Decodable {
            public let tableName: String
            public let recordId: Int
            public let modId: Int
            
            enum CodingKeys: CodingKey {
                case tableName
                case recordId
                case modId
            }
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.tableName = try container.decode(String.self, forKey: .tableName)
                let recordIdString = try container.decode(String.self, forKey: .recordId)
                let modIdString = try container.decode(String.self, forKey: .modId)
                guard let recordIdInt = Int(recordIdString) else {
                    let context = DecodingError.Context(codingPath: container.codingPath + [CodingKeys.recordId], debugDescription: "Error setting recordId to Int")
                    throw DecodingError.dataCorrupted(context)
                }
                guard let modIdInt = Int(modIdString) else {
                    let context = DecodingError.Context(codingPath: container.codingPath + [CodingKeys.modId], debugDescription: "Error setting modId to Int")
                    throw DecodingError.dataCorrupted(context)
                }
                self.recordId = recordIdInt
                self.modId = modIdInt
            }
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let modIdString = try container.decode(String.self, forKey: .modId)
            guard let modIdInt = Int(modIdString) else {
                let context = DecodingError.Context(codingPath: container.codingPath + [CodingKeys.modId], debugDescription: "Error setting modId to Int")
                throw DecodingError.dataCorrupted(context)
            }
            self.modId = modIdInt
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
    
    public enum ScriptItem: Decodable, Identifiable, Hashable {
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let name = try container.decode(String.self, forKey: .name)
            if let scriptFolder = try container.decodeIfPresent([ScriptItem].self, forKey: .folderScriptNames) {
                self = .folder(name, scripts: scriptFolder)
            } else {
                self = .script(name)
            }
        }
        
        case script(_ name: String, _ id: UUID = UUID())
        case folder(_ name: String, scripts: [ScriptItem], _ id: UUID = UUID())
        
        public enum CodingKeys: CodingKey {
            case name
            case folderScriptNames
        }
        
        public var name: String {
            switch self {
            case .script(let name, _):
                return name
            case .folder(let name, scripts: _, _):
                return name
            }
        }
        
        public var id: UUID {
            switch self {
            case .script(_, let id):
                return id
            case .folder(_, scripts: _, let id):
                return id
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



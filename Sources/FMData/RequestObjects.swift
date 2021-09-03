import Foundation

extension DataAPI {
    
    public struct RecordQuery: QueryParameter {
        
        public let script: ScriptQuery?
        public let layoutResponse: String?
        public let portal: [PortalRequest]?
        public let offset: String?
        public let limit: String?
        public let sortOrder: [SortQuery]?
        
        public init(script: ScriptQuery? = nil, layoutResponse: String? = nil, portal: [PortalRequest]? = nil, offset: String? = nil, limit: String? = nil, sortOrder: [SortQuery]? = nil) {
            self.script = script
            self.layoutResponse = layoutResponse
            self.portal = portal
            self.offset = offset
            self.limit = limit
            self.sortOrder = sortOrder
            
        }
        
        public init(script: ScriptQuery? = nil, layoutResponse: String? = nil, portal: [PortalRequest]? = nil, offset: Int? = nil, limit: Int? = nil, sortOrder: [SortQuery]? = nil) {
            let sLimit = limit == nil ? nil : "\(limit!)"
            let sOffset = offset == nil ? nil : "\(offset!)"
            self.init(script: script, layoutResponse: layoutResponse, portal: portal, offset: sOffset, limit: sLimit, sortOrder: sortOrder)
        }
        
        public init(script: ScriptQuery? = nil, layoutResponse: String? = nil, portal: [PortalRequest]? = nil) {
            self.script = script
            self.layoutResponse = layoutResponse
            self.portal = portal
            self.offset = nil
            self.limit = nil
            self.sortOrder = nil
        }
        
        enum CodingKeys: String, CodingKey, CaseIterable {
            case script
            case layoutResponse = "layout.response"
            case portal
            case offset = "_offset"
            case limit = "_limit"
            case sortOrder = "_sort"
        }
        
        public var queryParameters: [URLQueryItem] {
            
            let items:[[URLQueryItem]?] = CodingKeys.allCases.map { key in
                switch key {
                case .script:
                    guard let rScript = script else { return nil }
                    return rScript.queryParameters
                case .layoutResponse:
                    guard let layoutResp = layoutResponse else { return nil }
                    return [URLQueryItem(name: key.rawValue, value: layoutResp)]
                case .portal:
                    guard let portals = self.portal else { return nil }
                    let portalNames = portals.map{$0.name}.joined(separator: "\",\"")
                    var params = [URLQueryItem(name: key.rawValue, value: "[\"\(portalNames)\"]")]
                    let offsets = portals.map { $0.queryParameterOffset }.compactMap{ $0 }
                    let limits = portals.map { $0.queryParameterLimit }.compactMap{ $0 }
                    params.append(contentsOf: offsets)
                    params.append(contentsOf: limits)
                    return params
                case .offset:
                    guard let qOffset = self.offset else { return nil }
                    return [URLQueryItem(name: key.rawValue, value: qOffset)]
                case .limit:
                    guard let qLimit = self.limit else { return nil }
                    return [URLQueryItem(name: key.rawValue, value: qLimit)]
                case .sortOrder:
                    guard let newSort = self.sortOrder else { return nil }
                    let sortString = newSort.map {
                        "\"fieldName\":\"\($0.fieldName)\",\"sortOrder\":\"\($0.sortOrder)\""
                    }.joined(separator: "},{")
                    return [URLQueryItem(name: key.rawValue, value: "[{\(sortString)}]")]
                }
            }
            return items.flatMap{
                $0?.compactMap{$0} ?? []
            }
        }
        
    }
    
    public struct FindQuery: Encodable {
        public let query: [[String: String]]
        public let sortOrder: [SortQuery]?
        public let script: ScriptQuery?

        public let offset: Int?
        public let limit: Int?
        
        public let layoutResponse: String?
        public let portal: [PortalRequest]?
        
        public init(query: [[String: String]], sort: [SortQuery]? = nil, script: ScriptQuery? = nil, offset: Int? = nil, limit: Int? = nil, layoutResponse: String? = nil, portal: [PortalRequest]? = nil) {
            self.query = query
            self.sortOrder = sort
            self.script = script
            self.offset = offset
            self.limit = limit
            self.layoutResponse = layoutResponse
            self.portal = portal
        }
        
        enum CodingKeys: String, CodingKey {
            case query
            case sortOrder = "sort"
            case offset
            case limit
            case layoutResponse = "layout.response"
            case portal
            case script
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(query, forKey: .query)
            try container.encodeIfPresent(sortOrder, forKey: .sortOrder)
            try container.encodeIfPresent(offset, forKey: .offset)
            try container.encodeIfPresent(limit, forKey: .limit)
            try container.encodeIfPresent(layoutResponse, forKey: .layoutResponse)
            if let portalItems = self.portal {
                try container.encodeIfPresent(portalItems.map{$0.name}, forKey: .portal)
                var portalInfo = encoder.container(keyedBy: PortalRequest.DynamicKey.self)
                try portalItems.forEach {
                    try portalInfo.encodeIfPresent($0.limit, forKey: .key(named: "limit.\($0.name)"))
                    try portalInfo.encodeIfPresent($0.offset, forKey: .key(named: "offset.\($0.name)"))
                }
            }
  
            var scriptInfo = encoder.container(keyedBy: ScriptQuery.CodingKeys.self)
            try scriptInfo.encodeIfPresent(script?.script, forKey: .script)
            try scriptInfo.encodeIfPresent(script?.scriptParam, forKey: .scriptParam)
            try scriptInfo.encodeIfPresent(script?.scriptPreSort, forKey: .scriptPreSort)
            try scriptInfo.encodeIfPresent(script?.scriptPreSortParam, forKey: .scriptPreSortParam)
            try scriptInfo.encodeIfPresent(script?.scriptPreRequest, forKey: .scriptPreRequest)
            try scriptInfo.encodeIfPresent(script?.scriptPreRequestParam, forKey: .scriptPreRequestParam)
            }
    }
    
    public struct EditRecord<R: Encodable, P: Encodable>: Encodable {
        
        public let fieldData: R
        public let portalData: [String: P?]?
        public let modId: String?
        public let script: ScriptQuery?
        public let layoutResponse: String?
                
        enum CodingKeys: String, CodingKey {
            case fieldData
            case portalData
            case modId
            case script
            case layoutResponse = "layout.response"

        }
        
        public init(createRecord record: R, portalData: [String:P?]? = nil, script: ScriptQuery? = nil, layoutResponse: String? = nil) {
            self.fieldData = record
            self.portalData = portalData
            self.modId = nil
            self.script = script
            self.layoutResponse = layoutResponse
        }
        
        public init(editRecord record: R, portalData: [String:P?]? = nil, modId: String? = nil, script: ScriptQuery? = nil, layoutResponse: String? = nil) {
            self.fieldData = record
            self.portalData = portalData
            self.modId = modId
            self.script = script
            self.layoutResponse = layoutResponse
          
        }
        
        public init(editRecord record: R, modId: String? = nil, script: ScriptQuery? = nil, layoutResponse: String? = nil) where P == String? {
            self.fieldData = record
            self.portalData = nil
            self.modId = modId
            self.script = script
            self.layoutResponse = layoutResponse
          
        }
        
        public init(editRecords record: R, portalData: [String:P?]? = nil, modId: String? = nil, script: ScriptQuery? = nil, layoutResponse: String? = nil) {
            self.fieldData = record
            self.portalData = portalData
            self.modId = modId
            self.script = script
            self.layoutResponse = layoutResponse
          
        }
        
        public init(editRecords record: R, modId: String? = nil, script: ScriptQuery? = nil, layoutResponse: String? = nil) where P == String? {
            self.fieldData = record
            self.portalData = nil
            self.modId = modId
            self.script = script
            self.layoutResponse = layoutResponse
          
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(fieldData, forKey: .fieldData)
            try container.encodeIfPresent(portalData, forKey: .portalData)
            try container.encodeIfPresent(modId, forKey: .modId)
            try container.encodeIfPresent(layoutResponse, forKey: .layoutResponse)
            
            var scriptInfo = encoder.container(keyedBy: ScriptQuery.CodingKeys.self)
            try scriptInfo.encodeIfPresent(script?.script, forKey: .script)
            try scriptInfo.encodeIfPresent(script?.scriptParam, forKey: .scriptParam)
            try scriptInfo.encodeIfPresent(script?.scriptPreSort, forKey: .scriptPreSort)
            try scriptInfo.encodeIfPresent(script?.scriptPreSortParam, forKey: .scriptPreSortParam)
            try scriptInfo.encodeIfPresent(script?.scriptPreRequest, forKey: .scriptPreRequest)
            try scriptInfo.encodeIfPresent(script?.scriptPreRequestParam, forKey: .scriptPreRequestParam)
            }
        
    }
    
    //MARK: COMPONENTS
    
    public struct ScriptQuery: Encodable, QueryParameter {
        
        public let script: String?
        public let scriptParam: String?
        public let scriptPreSort: String?
        public let scriptPreSortParam: String?
        public let scriptPreRequest: String?
        public let scriptPreRequestParam: String?
        
        enum CodingKeys: String, CodingKey, CaseIterable {
            case script
            case scriptParam = "script.param"
            case scriptPreRequest = "script.prerequest"
            case scriptPreRequestParam = "script.prerequest.param"
            case scriptPreSort = "script.presort"
            case scriptPreSortParam = "script.presort.param"
        }
        
        public var queryParameters: [URLQueryItem] {
            
            Self.CodingKeys.allCases.map {
                switch $0 {
                case .script:
                    guard let qScript = self.script else { return nil }
                    return URLQueryItem(name: $0.rawValue, value: qScript)
                case .scriptParam:
                    guard let qScriptParam = self.scriptParam else { return nil }
                    return URLQueryItem(name: $0.rawValue, value: qScriptParam)
                case .scriptPreRequest:
                    guard let qScriptPreRequest = self.scriptPreRequest else { return nil }
                    return URLQueryItem(name: $0.rawValue, value: qScriptPreRequest)
                case .scriptPreRequestParam:
                    guard let qScriptPreRequestParam = self.scriptPreRequestParam else { return nil }
                    return URLQueryItem(name: $0.rawValue, value: qScriptPreRequestParam)
                case .scriptPreSort:
                    guard let qScriptPreSort = self.scriptPreSort else { return nil }
                    return URLQueryItem(name: $0.rawValue, value: qScriptPreSort)
                case .scriptPreSortParam:
                    guard let qScriptPreSortParam = self.scriptPreSortParam else { return nil }
                    return URLQueryItem(name: $0.rawValue, value: qScriptPreSortParam)
                }
            }.compactMap{ $0 }
        }
    }
    
    public struct SortQuery: Encodable {
        
        let fieldName: String
        let sortOrder: SortOrder
        
        public init(fieldName: String, sortOrder: SortOrder = .ascend) {
            self.fieldName = fieldName
            self.sortOrder = sortOrder
        }
        
        public enum SortOrder: String, Encodable {
            case ascend
            case descend
        }

    }
    
    public struct PortalRequest: Encodable {
        let name: String
        let limit: String?
        let offset: String?
        
        public init(name: String, limit: String? = nil, offset: String? = nil) {
            self.name = name
            self.limit = limit
            self.offset = offset
        }
        
        public init(name: String, limit: Int? = nil, offset: Int? = nil) {
            self.name = name
            if let iLimit = limit {
                self.limit = "\(iLimit)"
            } else {
                self.limit = nil
            }
            if let iOffset = offset {
                self.offset = "\(iOffset)"
            } else {
                self.offset = nil
            }
        }
        
        public init(name: String) {
            self.name = name
            self.limit = nil
            self.offset = nil
        }
        
        var queryParameterLimit: URLQueryItem? {
            guard let portalLimit = limit else { return nil }
            return URLQueryItem(name: "_limit.\(name)", value: portalLimit)
        }
        
        var queryParameterOffset: URLQueryItem? {
            guard let portalOffset = offset else { return nil }
            return URLQueryItem(name: "_offset.\(name)", value: portalOffset)
        }
        
        struct DynamicKey: CodingKey {
            var stringValue: String

            init?(stringValue: String) {
                self.stringValue = stringValue
            }

            var intValue: Int?

            init?(intValue: Int) {
                self.intValue = intValue
                self.stringValue = "\(intValue)"
            }

            static func key(named name: String) -> Self {
                return DynamicKey(stringValue: name)!
            }

        }

    }
    
}

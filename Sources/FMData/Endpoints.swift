import Foundation
import FMRest

extension DataAPI {
    
    public enum Endpoint: EndpointPath {
        
        case productInfo
        case databaseNames
        case layoutNames(database: String)
        case scriptNames(database: String)
        case layoutMetadata(database: String, layout: String)
        case layoutMetadataOld(database: String, layout: String)
        case auth(database: String)
        case deAuth(database: String, token: String)
        case validate
        case getRecords(database: String, layout: String)
        case createRecord(database: String, layout: String)
        case getRecord(database: String, layout: String, recordId: Int)
        case editRecord(database: String, layout: String, recordId: Int)
        case deleteRecord(database: String, layout: String, recordId: Int)
        case duplicateRecord(database: String, layout: String, recordId: Int)
        case findRecords(database: String, layout: String)
        case executeScript(database: String, layout: String, scriptName: String)
        case uploadToContainer(database: String, layout: String, recordId: Int, containerName: String, fieldRepetition: Int?)
        case setGlobalFields(database: String)
        
        public var path: String {
            
            switch self {
            case .productInfo:
                return "/productInfo"
            case .databaseNames:
                return "/databases"
            case .layoutNames(let database):
                return "/databases/\(database)/layouts"
            case .scriptNames(let database):
                return "/databases/\(database)/scripts"
            case .layoutMetadata(let database, let layout):
                return "/databases/\(database)/layouts/\(layout)"
            case .layoutMetadataOld(let database, let layout):
                return "/databases/\(database)/layouts/\(layout)/metadata"
            case .auth(database: let database):
                return "/databases/\(database)/sessions"
            case .deAuth(let database, let token):
                return "/databases/\(database)/sessions/\(token)"
            case .validate:
                return "/validateSession"
            case .getRecords(database: let database, layout: let layout):
                return "/databases/\(database)/layouts/\(layout)/records"
            case .createRecord(let database, let layout):
                return "/databases/\(database)/layouts/\(layout)/records"
            case .getRecord(let database,  let layout, recordId: let recordId):
                return "/databases/\(database)/layouts/\(layout)/records/\(recordId)"
            case .editRecord(let database,let layout, recordId: let recordId):
                return "/databases/\(database)/layouts/\(layout)/records/\(recordId)"
            case .deleteRecord(let database, let layout, recordId: let recordId):
                return "/databases/\(database)/layouts/\(layout)/records/\(recordId)"
            case .duplicateRecord(let database, let layout, recordId: let recordId):
                return "/databases/\(database)/layouts/\(layout)/records/\(recordId)"
            case .findRecords(let database, let layout):
                return "/databases/\(database)/layouts/\(layout)/_find"
            case .executeScript(let database, let layout, let scriptName):
                return "/databases/\(database)/layouts/\(layout)/script/\(scriptName)"
            case .uploadToContainer(let database, let layout, let recordId, let containerName, let fieldRepetition):
                return "/databases/\(database)/layouts/\(layout)/records/\(recordId)/containers/\(containerName)/\(fieldRepetition ?? 1)"
            case .setGlobalFields(database: let database):
                return "/databases/\(database)/globals/"
            }
            
        }
        
        public var method: FMRest.HTTPMethod {
            
            switch self {
            case .productInfo:
                return .get
            case .databaseNames:
                return .get
            case .layoutNames(database: _):
                return .get
            case .scriptNames(database: _):
                return .get
            case .layoutMetadata(database: _, layout: _):
                return .get
            case .layoutMetadataOld(database: _, layout: _):
                return .get
            case .auth(database: _):
                return .post
            case .deAuth(database: _, token: _):
                return .delete
            case .validate:
                return .get
            case .getRecords(database: _, layout: _):
                return .get
            case .createRecord(database: _, layout: _):
                return .post
            case .getRecord(database: _, layout: _, recordId: _):
                return .get
            case .editRecord(database: _, layout: _, recordId: _):
                return .patch
            case .deleteRecord(database: _, layout: _, recordId: _):
                return .delete
            case .duplicateRecord(database: _, layout: _, recordId: _):
                return .post
            case .findRecords(database: _, layout: _):
                return .post
            case .executeScript(database: _, layout: _, scriptName: _):
                return .get
            case .uploadToContainer(database: _, layout: _, recordId: _, containerName: _, fieldRepetition: _):
                return .post
            case .setGlobalFields(database: _):
                return .patch
            }
            
        }
        
    }
    
}

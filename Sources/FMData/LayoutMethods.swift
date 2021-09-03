import Foundation
import Combine
import FMRest

extension DataAPI.Layout {
    
    //MARK: Records
    
    public func getRecords<R: Decodable, P: Decodable>(recordQuery: DataAPI.RecordQuery? = nil) -> AnyPublisher<DataAPI.RecordResponse<R,P>, FMRest.APIError>  {
        
        typealias Output = DataAPI.RecordResponse<R,P>
        guard let database = self.database else {
            return Fail<Output, FMRest.APIError>(error: FMRest.APIError.apiError(message: "No database associated with layout")).eraseToAnyPublisher()
        }
        guard let server = database.server else {
            return Fail<Output, FMRest.APIError>(error: .apiError(message: "no attached server")).eraseToAnyPublisher()
        }
        do {
            let request = try DataAPI.createRequest(credentials: database.credentials, server: server, endpoint: .getRecords(database: database.name, layout: self.name), queryParameters: recordQuery?.queryParameters ?? [])
            return FMRest.Agent.run(request, config: server.config)
                .dataAPIResponse()
                .eraseToAnyPublisher()
        } catch {
            return Fail<Output, FMRest.APIError>(error: error as! FMRest.APIError).eraseToAnyPublisher()
        }
        
    }
    
    public func createRecord<R: Encodable, P: Encodable>(record: DataAPI.EditRecord<R,P>) -> AnyPublisher<DataAPI.CreateResponse, FMRest.APIError> {
        
        typealias Output = DataAPI.CreateResponse
        guard let database = self.database else {
            return Fail<Output, FMRest.APIError>(error: FMRest.APIError.apiError(message: "No database associated with layout")).eraseToAnyPublisher()
        }
        guard let server = database.server else {
            return Fail<Output, FMRest.APIError>(error: .apiError(message: "no attached server")).eraseToAnyPublisher()
        }
        do {
            let request = try DataAPI.createRequest(credentials: database.credentials, server: server, endpoint: .createRecord(database: database.name, layout: self.name), body: record)
            return FMRest.Agent.run(request, config: server.config)
                .dataAPIResponse()
                .eraseToAnyPublisher()
        } catch {
            return Fail<Output, FMRest.APIError>(error: error as! FMRest.APIError).eraseToAnyPublisher()
        }
        
    }
    
    public func getRecordById<R: Decodable, P: Decodable>(recordId: Int, recordQuery: DataAPI.RecordQuery? = nil) -> AnyPublisher<DataAPI.RecordResponse<R,P>, FMRest.APIError> {
        
        typealias Output = DataAPI.RecordResponse<R,P>
        guard let database = self.database else {
            return Fail<Output, FMRest.APIError>(error: FMRest.APIError.apiError(message: "No database associated with layout")).eraseToAnyPublisher()
        }
        guard let server = database.server else {
            return Fail<Output, FMRest.APIError>(error: .apiError(message: "no attached server")).eraseToAnyPublisher()
        }
        do {
            let request = try DataAPI.createRequest(credentials: database.credentials, server: server, endpoint: .getRecord(database: database.name, layout: self.name, recordId: recordId), queryParameters: recordQuery?.queryParameters ?? [])
            return FMRest.Agent.run(request, config: server.config)
                .dataAPIResponse()
                .eraseToAnyPublisher()
        } catch {
            return Fail<Output, FMRest.APIError>(error: error as! FMRest.APIError).eraseToAnyPublisher()
        }
        
    }
    
    public func editRecord<R: Encodable, P: Encodable>(record: DataAPI.EditRecord<R,P>, recordId: Int) -> AnyPublisher<DataAPI.EditRecordResponse, FMRest.APIError> {
        
        typealias Output = DataAPI.EditRecordResponse
        guard let database = self.database else {
            return Fail<Output, FMRest.APIError>(error: FMRest.APIError.apiError(message: "No database associated with layout")).eraseToAnyPublisher()
        }
        guard let server = database.server else {
            return Fail<Output, FMRest.APIError>(error: .apiError(message: "no attached server")).eraseToAnyPublisher()
        }
        do {
            let request = try DataAPI.createRequest(credentials: database.credentials, server: server, endpoint: .editRecord(database: database.name, layout: self.name, recordId: recordId), body: record)
            return FMRest.Agent.run(request, config: server.config)
                .dataAPIResponse()
                .eraseToAnyPublisher()
        } catch {
            return Fail<Output, FMRest.APIError>(error: error as! FMRest.APIError).eraseToAnyPublisher()
        }
        
    }
    
    public func deleteRecord(recordId: Int, scriptQuery: DataAPI.ScriptQuery? = nil) -> AnyPublisher<DataAPI.ScriptResponse, FMRest.APIError> {
        
        typealias Output = DataAPI.ScriptResponse
        guard let database = self.database else {
            return Fail<Output, FMRest.APIError>(error: FMRest.APIError.apiError(message: "No database associated with layout")).eraseToAnyPublisher()
        }
        guard let server = database.server else {
            return Fail<Output, FMRest.APIError>(error: .apiError(message: "no attached server")).eraseToAnyPublisher()
        }
        do {
            let request = try DataAPI.createRequest(credentials: database.credentials, server: server, endpoint: .deleteRecord(database: database.name, layout: self.name, recordId: recordId), queryParameters: scriptQuery?.queryParameters ?? [])
            return FMRest.Agent.run(request, config: server.config)
                .dataAPIResponse()
                .eraseToAnyPublisher()
        } catch {
            return Fail<Output, FMRest.APIError>(error: error as! FMRest.APIError).eraseToAnyPublisher()
        }
        
    }
    
    public func duplicateRecord(recordId: Int, scriptQuery: DataAPI.ScriptQuery? = nil) -> AnyPublisher<DataAPI.ScriptResponse, FMRest.APIError>  {
        
        typealias Output = DataAPI.ScriptResponse
        guard let database = self.database else {
            return Fail<Output, FMRest.APIError>(error: FMRest.APIError.apiError(message: "No database associated with layout")).eraseToAnyPublisher()
        }
        guard let server = database.server else {
            return Fail<Output, FMRest.APIError>(error: .apiError(message: "no attached server")).eraseToAnyPublisher()
        }
        do {
            let request = try DataAPI.createRequest(credentials: database.credentials, server: server, endpoint: .duplicateRecord(database: database.name, layout: self.name, recordId: recordId), body: scriptQuery)
            return FMRest.Agent.run(request, config: server.config)
                .dataAPIResponse()
                .eraseToAnyPublisher()
        } catch {
            return Fail<Output, FMRest.APIError>(error: error as! FMRest.APIError).eraseToAnyPublisher()
        }
        
    }
    
    public func findRecords<R: Decodable, P: Decodable>(query: DataAPI.FindQuery) -> AnyPublisher<DataAPI.RecordResponse<R,P>, FMRest.APIError>  {
        
        typealias Output = DataAPI.RecordResponse<R,P>
        guard let database = self.database else {
            return Fail<Output, FMRest.APIError>(error: FMRest.APIError.apiError(message: "No database associated with layout")).eraseToAnyPublisher()
        }
        guard let server = database.server else {
            return Fail<Output, FMRest.APIError>(error: .apiError(message: "no attached server")).eraseToAnyPublisher()
        }
        do {
            let request = try DataAPI.createRequest(credentials: database.credentials, server: server, endpoint: .findRecords(database: database.name, layout: self.name), body: query)
            return FMRest.Agent.run(request, config: server.config)
                .dataAPIResponse()
                .eraseToAnyPublisher()
        } catch {
            return Fail<Output, FMRest.APIError>(error: error as! FMRest.APIError).eraseToAnyPublisher()
        }
        
    }
    
    //MARK: Script
    
    public func executeScript(script: String, scriptParam: String? = nil) -> AnyPublisher<DataAPI.ScriptResponse, FMRest.APIError> {
        
        typealias Output = DataAPI.ScriptResponse
        guard let database = self.database else {
            return Fail<Output, FMRest.APIError>(error: FMRest.APIError.apiError(message: "No database associated with layout")).eraseToAnyPublisher()
        }
        guard let server = database.server else {
            return Fail<Output, FMRest.APIError>(error: .apiError(message: "no attached server")).eraseToAnyPublisher()
        }
        do {
            let request = try DataAPI.createRequest(credentials: database.credentials, server: server, endpoint: .executeScript(database: database.name, layout: self.name, scriptName: script), queryParameters: [URLQueryItem(name: "script.param", value: scriptParam)])
            return FMRest.Agent.run(request, config: server.config)
                .dataAPIResponse()
                .eraseToAnyPublisher()
        } catch {
            return Fail<Output, FMRest.APIError>(error: error as! FMRest.APIError).eraseToAnyPublisher()
        }
        
    }
    
    
    //MARK: Upload To Container
    
    public func uploadToContainerField(fieldName: String, recordId: Int, repetition: Int?, modId: Int?, file: FMRest.ContainerFile) -> AnyPublisher<FMRest.EmptyResponse, FMRest.APIError> {
        
        typealias Output = FMRest.EmptyResponse
        guard let database = self.database else {
            return Fail<Output, FMRest.APIError>(error: FMRest.APIError.apiError(message: "No database associated with layout")).eraseToAnyPublisher()
        }
        guard let server = database.server else {
            return Fail<Output, FMRest.APIError>(error: .apiError(message: "no attached server")).eraseToAnyPublisher()
        }
        do {
            var queryParam: [URLQueryItem] = []
            if let recordModId = modId {
                queryParam.append(URLQueryItem(name: "modId", value: "\(recordModId)"))
            }
            let request = try DataAPI.createUploadRequest(credentials: database.credentials, server: server, endpoint: .uploadToContainer(database: database.name, layout: self.name, recordId: recordId, containerName: fieldName, fieldRepetition: repetition), queryParameters: queryParam, data: file)
            return FMRest.Agent.run(request, config: server.config)
                .dataAPIResponse()
                .eraseToAnyPublisher()
        } catch {
            return Fail<Output, FMRest.APIError>(error: error as! FMRest.APIError).eraseToAnyPublisher()
        }
        
    }
    
    //MARK: Layout Metadata
    
    public func getLayoutMetadata(recordId: Int?) -> AnyPublisher<LayoutMetaData, FMRest.APIError> {
        
        typealias Output = LayoutMetaData
        guard let database = self.database else {
            return Fail<Output, FMRest.APIError>(error: FMRest.APIError.apiError(message: "No database associated with layout")).eraseToAnyPublisher()
        }
        guard let server = database.server else {
            return Fail<Output, FMRest.APIError>(error: .apiError(message: "no attached server")).eraseToAnyPublisher()
        }
        do {
            var queryParams: [URLQueryItem] = []
            if let record = recordId {
                queryParams.append(URLQueryItem(name: "recordId", value: "\(record)"))
            }
            let request = try DataAPI.createRequest(credentials: database.credentials, server: server, endpoint: .layoutMetadata(database: database.name, layout: self.name), queryParameters: queryParams)
            return FMRest.Agent.run(request, config: server.config)
                .dataAPIResponse()
                .eraseToAnyPublisher()
        } catch {
            return Fail<Output, FMRest.APIError>(error: error as! FMRest.APIError).eraseToAnyPublisher()
        }
        
    }
    
}

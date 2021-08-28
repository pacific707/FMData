import Foundation
import Combine
import FMRest

extension DataAPI.Layout {
    
    //MARK: Records
    
    public func getRecords<R: Decodable, P: Decodable>(recordQuery: DataAPI.RecordQuery? = nil) -> AnyPublisher<DataAPI.RecordResponse<R,P>, FMRest.APIError>  {
        
        if let database = self.database {
            let requestWrapper = DataAPI.createRequest(credentials: database.credentials, server: database.server, endpoint: .getRecords(database: database.name, layout: self.name), queryParameters: recordQuery?.queryParameters ?? [])
            switch requestWrapper {
            case .success(let request):
                print(request)
                return FMRest.Agent.run(request)
                    .dataAPIResponse()
                    .eraseToAnyPublisher()
            case .failure(let error):
                return Fail<DataAPI.RecordResponse<R,P>, FMRest.APIError>(error: error).eraseToAnyPublisher()
            }
        } else {
            return Fail<DataAPI.RecordResponse<R,P>, FMRest.APIError>(error: FMRest.APIError.apiError(message: "No database associated with layout")).eraseToAnyPublisher()
        }
        
    }
    
    public func createRecord<R: Encodable, P: Encodable>(record: DataAPI.EditRecord<R,P>) -> AnyPublisher<DataAPI.CreateResponse, FMRest.APIError> {
        
        if let database = self.database {
            let requestWrapper = DataAPI.createRequest(credentials: database.credentials, server: database.server, endpoint: .createRecord(database: database.name, layout: self.name), body: record)
            switch requestWrapper {
            case .success(let request):
                return FMRest.Agent.run(request)
                    .dataAPIResponse()
                    .eraseToAnyPublisher()
            case .failure(let error):
                return Fail<DataAPI.CreateResponse, FMRest.APIError>(error: error).eraseToAnyPublisher()
            }
        } else {
            return Fail<DataAPI.CreateResponse, FMRest.APIError>(error: FMRest.APIError.apiError(message: "No database associated with layout")).eraseToAnyPublisher()
        }
        
    }
    
    public func getRecordById<R: Decodable, P: Decodable>(recordId: Int, recordQuery: DataAPI.RecordQuery? = nil) -> AnyPublisher<DataAPI.RecordResponse<R,P>, FMRest.APIError> {
        
        if let database = self.database {
            let requestWrapper = DataAPI.createRequest(credentials: database.credentials, server: database.server, endpoint: .getRecord(database: database.name, layout: self.name, recordId: recordId), queryParameters: recordQuery?.queryParameters ?? [])
            switch requestWrapper {
            case .success(let request):
                return FMRest.Agent.run(request)
                    .dataAPIResponse()
                    .eraseToAnyPublisher()
            case .failure(let error):
                return Fail<DataAPI.RecordResponse<R,P>, FMRest.APIError>(error: error).eraseToAnyPublisher()
            }
        } else {
            return Fail<DataAPI.RecordResponse<R,P>, FMRest.APIError>(error: FMRest.APIError.apiError(message: "No database associated with layout")).eraseToAnyPublisher()
        }
    }
    
    public func editRecord<R: Encodable, P: Encodable>(record: DataAPI.EditRecord<R,P>, recordId: Int) -> AnyPublisher<DataAPI.EditRecordResponse, FMRest.APIError> {
        
        if let databases = self.database {
            let requestWrapper = DataAPI.createAuthRequest(credentials: databases.credentials, server: databases.server, endpoint: .editRecord(database: databases.name, layout: self.name, recordId: recordId), body: record)
            switch requestWrapper {
            case .success(let request):
                return FMRest.Agent.run(request)
                    .dataAPIResponse()
                    .eraseToAnyPublisher()
            case .failure(let error):
                return Fail<DataAPI.EditRecordResponse, FMRest.APIError>(error: error).eraseToAnyPublisher()
            }
        } else {
            return Fail<DataAPI.EditRecordResponse, FMRest.APIError>(error: FMRest.APIError.apiError(message: "No database associated with layout")).eraseToAnyPublisher()
        }
        
    }
    
    public func deleteRecord(recordId: Int, scriptQuery: DataAPI.ScriptQuery? = nil) -> AnyPublisher<DataAPI.ScriptResponse, FMRest.APIError> {
        
        if let database = self.database {
            let requestWrapper = DataAPI.createRequest(credentials: database.credentials, server: database.server, endpoint: .deleteRecord(database: database.name, layout: self.name, recordId: recordId), queryParameters: scriptQuery?.queryParameters ?? [])
            switch requestWrapper {
            case .success(let request):
                return FMRest.Agent.run(request)
                    .dataAPIResponse()
                    .eraseToAnyPublisher()
            case .failure(let error):
                return Fail<DataAPI.ScriptResponse, FMRest.APIError>(error: error).eraseToAnyPublisher()
            }
        } else {
            return Fail<DataAPI.ScriptResponse, FMRest.APIError>(error: FMRest.APIError.apiError(message: "No database associated with layout")).eraseToAnyPublisher()
        }
        
    }
    
    public func duplicateRecord(recordId: Int, scriptQuery: DataAPI.ScriptQuery? = nil) -> AnyPublisher<DataAPI.ScriptResponse, FMRest.APIError>  {
        
        if let database = self.database {
            let requestWrapper = DataAPI.createRequest(credentials: database.credentials, server: database.server, endpoint: .duplicateRecord(database: database.name, layout: self.name, recordId: recordId), body: scriptQuery)
            switch requestWrapper {
            case .success(let request):
                return FMRest.Agent.run(request)
                    .dataAPIResponse()
                    .eraseToAnyPublisher()
            case .failure(let error):
                return Fail<DataAPI.ScriptResponse, FMRest.APIError>(error: error).eraseToAnyPublisher()
            }
        } else {
            return Fail<DataAPI.ScriptResponse, FMRest.APIError>(error: FMRest.APIError.apiError(message: "No database associated with layout")).eraseToAnyPublisher()
        }
        
    }
    
    public func findRecords<R: Decodable, P: Decodable>(query: DataAPI.FindQuery) -> AnyPublisher<DataAPI.RecordResponse<R,P>, FMRest.APIError>  {
        
        if let database = self.database {
            let requestWrapper = DataAPI.createRequest(credentials: database.credentials, server: database.server, endpoint: .findRecords(database: database.name, layout: self.name), body: query)
            switch requestWrapper {
            case .success(let request):
                return FMRest.Agent.run(request)
                    .dataAPIResponse()
                    .eraseToAnyPublisher()
            case .failure(let error):
                return Fail<DataAPI.RecordResponse<R,P>, FMRest.APIError>(error: error).eraseToAnyPublisher()
            }
        } else {
            return Fail<DataAPI.RecordResponse<R,P>, FMRest.APIError>(error: FMRest.APIError.apiError(message: "No database associated with layout")).eraseToAnyPublisher()
        }
        
    }
    
    //MARK: Script
    
    public func executeScript(script: String, scriptParam: String? = nil) -> AnyPublisher<DataAPI.ScriptResponse, FMRest.APIError> {
        
        if let database = self.database {
            let requestWrapper = DataAPI.createRequest(credentials: database.credentials, server: database.server, endpoint: .executeScript(database: database.name, layout: self.name, scriptName: script), queryParameters: [URLQueryItem(name: "script.param", value: scriptParam)])
            switch requestWrapper {
            case .success(let request):
                return FMRest.Agent.run(request)
                    .dataAPIResponse()
                    .eraseToAnyPublisher()
            case .failure(let error):
                return Fail<DataAPI.ScriptResponse, FMRest.APIError>(error: error).eraseToAnyPublisher()
            }
        } else {
            return Fail<DataAPI.ScriptResponse, FMRest.APIError>(error: FMRest.APIError.apiError(message: "No database associated with layout")).eraseToAnyPublisher()
        }
    }
    
    
    //MARK: Upload To Container
    
    public func uploadToContainerField(fieldName: String, recordId: Int, repetition: Int?, modId: Int?, file: FMRest.ContainerFile) -> AnyPublisher<FMRest.EmptyResponse, FMRest.APIError> {
        
        if let database = self.database {
            var queryParam: [URLQueryItem] = []
            if let recordModId = modId {
                queryParam.append(URLQueryItem(name: "modId", value: "\(recordModId)"))
            }
            let requestWrapper = DataAPI.createUploadRequest(credentials: database.credentials, server: database.server, endpoint: .uploadToContainer(database: database.name, layout: self.name, recordId: recordId, containerName: fieldName, fieldRepetition: repetition), queryParameters: queryParam, data: file)
            switch requestWrapper {
            case .success(let request):
                return FMRest.Agent.run(request)
                    .dataAPIResponse()
                    .eraseToAnyPublisher()
            case .failure(let error):
                return Fail<FMRest.EmptyResponse, FMRest.APIError>(error: error).eraseToAnyPublisher()
            }
        } else {
            return Fail<FMRest.EmptyResponse, FMRest.APIError>(error: FMRest.APIError.apiError(message: "No database associated with layout")).eraseToAnyPublisher()
        }
    }
    
    //MARK: Layout Metadata
    
    public func getLayoutMetadata(recordId: Int?) -> AnyPublisher<LayoutMetaData, FMRest.APIError> {
        
        if let database = self.database {
            var queryParams: [URLQueryItem] = []
            if let record = recordId {
                queryParams.append(URLQueryItem(name: "recordId", value: "\(record)"))
            }
            let requestWrapper = DataAPI.createRequest(credentials: database.credentials, server: database.server, endpoint: .layoutMetadata(database: database.name, layout: self.name), queryParameters: queryParams)
            switch requestWrapper {
            case .success(let request):
                return FMRest.Agent.run(request)
                    .dataAPIResponse()
                    .eraseToAnyPublisher()
            case .failure(let error):
                return Fail<LayoutMetaData, FMRest.APIError>(error: error).eraseToAnyPublisher()
            }
        } else {
            return Fail<LayoutMetaData, FMRest.APIError>(error: FMRest.APIError.apiError(message: "No database associated with layout")).eraseToAnyPublisher()
        }
    }
    
    
}


# FMData

A comprehensive and declarative Library to use the FileMaker Data API.  This library exposes the FileMaker Data API as Combine Publishers.  This library takes advantage of the use of generics to keep things type safe and provide better debugging.  All basic query and request structs are provided that match the data api.  All you need to provide is your encodable response objects.

 ![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)
---
### Index

- [Features](#Features)
- [Setting up](#Setting-up)
    - [Initializing a server](#Initializing-a-server)
    - [Adding a database](#Adding-a-database-to-a-server)
    - [Add layouts to a database](#Add-layouts-to-a-database)
- [Request Objects](#Request-Objects)
    - [Authentication Objects](#Authentication-Objects)
        - [Credentials](#Credentials)
        - [FMDataSourceAuth](#FMDataSourceAuth)
    - [Request Objects](#Request-Objects)
        - [Script Query](#Script-Query)
        - [Portal Query](#Portal-Query)
        - [Sort Query](#Sort-Query)
        - [Record Query](#Record-Query)
        - [Find Query](#Find-Query)
        - [Edit Record](#Edit-Record)
- [Response Objects](#Response-Objects)
    - [Meta Data](#Meta-Data)
        - [Product Info](#Product-Info)
        - [Database Names](#Database-Names)
        - [Layout Names](#Layout-Names)
        - [Script Names](#Script-Names)
        - [Layout Metadata](#Layout-Metadata)
    - [Record Objects](#Record-Objects)
- [Publishers (endpoints)](#Publishers-(endpoints))
    - [Metadata](#Metadata)
        - [Product info](#Product-Info)
        - [Database Names](#Database-Names)
        - [Layout Names](#Layout-Names)
        - [Script Names](#Script-Names)
        - [Layout Metadata](#Layout-Metadata)
    - [Authentication](#Authentication)
        - [Login](#Login)
        - [Log Out](#Log-Out)
        - [Validate Session](#Validate-Session)
    - [Records](#Records)
        - [Get Records](#Get-Records)
        - [Create Record](#Create-Record)
        - [Get Single Record By Id](#Get-Single-Record-By-Id)
        - [Edit Record](#Edit-Record)
        - [Delete Record](#Delete-Record)
        - [Duplicate Record](#Duplicate-Record)
        - [Find Records](#Find-Records)
    - [Scripts](#Scripts)
        - [Execute Script](#Execute-Script)
    - [Container](#Container)
        - [Upload To Container Field](#Upload-To-Container-Field)
        - [Upload To Container Field ( Specific repetition )](#Upload-To-Container-Field-(-specific-repetition-))
    - [Globals](#Globals)
        - [Set Global Fields](#Set-Global-Fields)

### Features

* Combine Publishers
* Token Management
* Multi database or server
* Type safe using generics
* Support for ClarisID
* Oath
* External data source auth
* Supports FileMaker Server 18+


# Using FMData


Each method is called from the context of the main three objects **Server**, **Database** and **Layout**.  You can also reach each object from the context of the child. Example for a layout called "contacts" you could reach the server object as shown: ```contacts.database.server```.

### Setting up

In these examples we are setting up a single server and working with one database. You could be using many servers, databases and layouts. The relation of which is a simple tree structure where a server can have many databases, a database can have many layouts. 
When you make a call from the context of the layout the call uses information from up the tree. It knows the server host from the server object. It gets the credentials stored in the database object etc. 

You would likely be setting up the server, database and layouts in you apps model. 

### Initializing a server

We start by creating our server 

```swift
let myServer = DataAPI.Server(host: "www.example.com")
``` 

#### Adding a database to a server

```swift
let myDatabase = myServer.addDatabase("databaseName")
```
if you will be using one database the whole time so you can initialize the database and server at once. Then you could just access the server from the database when needed.

```swift
let myDatabase = DataAPI.Server(host: "www.example.com").addDatabase("databaseName")
```

#### Add layouts to a database

Layouts need to be defined with a LayoutKey protocol

```swift
enum Layouts: String, LayoutKey {
    case myLayout
    case myOtherLayout
}
```

```swift
let myLayout = myDatabase.addLayout(LayoutSet.myLayout)
```

Again if you are only using one layout you can define all three at once and just access the server and database from the layout. 

```swift
let myLayout = myServer("www.example.com).addDatabase("databaseName").addLayout(LayoutSet.myLayout)
```
-
## Request Objects

### Authentication Objects
#### Credentials
The credentials object is stored in the database object.  It is initialized as basic, oAuth or Claris ID.  On successful login it is replaced by a token.  The credentials object is published so if you have a timer or something observing you can act on the change when it flips to invalid.

```swift
//Basic Auth
let credentials = Credentials(user: String, password: String)

//OAuth
let credentials = Credentials(oAuthId: String, oAuthIdentifier: String)

//ClarisId
let credentials = Credentials(clarisId: String)
```
#### FMDataSourceAuth
If you are connecting to a database with an external data source that needs separate authentication you can send an array of FMDataSourceAuth

```swift
//Basic Auth
let dataSourceAuth = FMDataSourceAuth(fmDataSource: [
                                        .init(
                                            database: "externalDb",
                                            credentials: .basic(
                                                user: "userName",
                                                password: "password"
                                            )
                                        )
])
//OAuth
let dataSourceAuth = FMDataSourceAuth(fmDataSource: [
                                        .init(
                                            database: "externalDb",
                                            credentials: .oAuth(
                                                requestId: "requestString",
                                                identifier: "identifierString"
                                            )
                                        )
])
```
### Request Objects

#### Script Query

A script query can be pass with any Record request.  The script will be processed on server and the result will be optionally be returned in the response object
```swift
let scriptQuery = ScriptQuery(
    script: String?,
    scriptParam: String?,
    scriptPreSort: String?,
    scriptPreSortParam: String?,
    scriptPreRequest: String?,
    scriptPreRequestParam: String?
)
```
#### Portal Query

A portal can be sent in with calls that return records.  The portal array will have the name of the portal to return and optional limits and offsets for each portal
```swift
let portals = [
    PortalRequest(name: "portalName"),
    PortalRequest(
        name: "portalName2",
        limit: 30,
        offset: 10)
]
````

#### Sort Query

Requests that return multiple records can have a sort paramter.  Its simply an array of the field name and order. Not providing the order will default to ascend.
```swift
let sort = [
    SortQuery(fieldName: "fieldName"),
    SortQuery(fieldName: "fieldName2", sortOrder: .descend)
]
```

#### Record Query

A record query can optionally be sent with get records requests to specify scripts to run layouts response portals and offsets etc.
```swift
let recordQuery = RecordQuery(
    script: ScriptQuery?,
    layoutResponse: String?,
    portal: [Portal]?,
    offset: String?,
    limit: String?,
    sortOrder: [SortQuery]?
)
```
#### Find Query

A Find query can specify field and values of the records you want to find on.  You can also include scripts offsets etc like other calls.  Only the basic query is required. 
```swift
let find = FindQuery(
    query: [["fieldName" : "fieldValue"]],
    sort: [SortQuery]?,
    script: ScriptQuery?,
    offset: Int?,
    limit: Int?,
    layoutResponse: String?,
    portal: [Portal]?
)
```
#### Edit Record

An Edit records query should have the updated record you are editing.  It can include portal data.  Portals needs to be named.  The object used to make this request should be the same as what is returned.  The EditRecord object is used to update and create new objects. 
```swift
//init for editing
let updated = EditRecord(
    editRecord: R,
    portalData: P?,
    modId: String?,
    script: ScriptQuery?,
    layoutResponse: String?)

//simple example - the RecordID of the record to edit is provided in the call
let updated = EditRecord(editRecord: myObject)

//init for creating
let updated = EditRecord(
    createRecord: R,
    portalData: P?,
    script: ScriptQuery?,
    layoutResponse: String?
)

//simple new record
let newRecord = EditRecord(createRecord: myObject)
```
## Response Objects

### Meta Data

#### Product Info
```swift
public struct ProductInfo: Decodable {
    public let buildDate: String
    public let name: String
    public let version: String
    public let dateFormat: String
    public let timeFormat: String
    public let timeStampFormat: String
}
```
#### Database Names

```swift
public struct DatabaseListResponse: Decodable {
    
    public let databases: [DatabaseName]
    
    public struct DatabaseName: Decodable {
        public let name: String
    }
    
}
```
#### Layout Names

Layout names are received as a list of enums.  Each one being a Layout object or a folder recursively 
```swift
public enum LayoutListItem: Decodable {
    
    case layout(layout: DataAPI.Layout)
    case folder(name: String, layouts: [LayoutListItem])
    
    public var name: String { get }
}

```
#### Script Names

Script names are received as a list of enums. Each one being a name or folder recursively
```swift
public enum ScriptItem: Decodable {
    
    case script(_ name: String)
    case folder(_ name: String, scripts: [ScriptItem])
    
    public var name: String { get }
}
```
#### Layout Metadata

```swift
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
```
### Record Objects

#### Script Response

Any response where a script is called can have a scriptResponse.
```swift
public struct ScriptResponse: Decodable {
    public let scriptResult: String?
    public let scriptError: String?
    public let scriptErrorPreRequest: String?
    public let scriptResultPreRequest: String?
    public let scriptResultPreSort: String?
    public let scriptErrorPreSort: String?
    
}
```

#### Record Response

A record response has the generic object and generic portal object you specified.  Both need to be decodable.  In the often case where there is no portal records and EmptyPortal object can be used. If you want to have multi portals they need to be created like this
```swift

public struct ExamplePortal: Decodable {

// the name of these let variables are the names of the 
// portals or you can make a coding key for them.
    let portal1: [PortalObject1]
    let portal2: [PortalObject2]

    struct PortalObject1 : DataAPIPortalRecord {
        var recordId: String
        var modId: String
        ...
    }
    
    struct PortalObject2: DataAPIPortalRecord {
        var recordId: String
        var modId: String
        ...
    }
}
```
Here is the basic response record.  For convenience you can supply the empty portal struct when no portal is needed.
```swift
public struct RecordResponse<R: Decodable, P:Decodable>: Decodable {
    
    public let data: [Record<R,P>]
    public let dataInfo: DataInfo
    public let scriptResponse: ScriptResponse?
    
    public struct Record<R: Decodable>: Decodable {
        public let fieldData: R
        public let portalData: P?
        public let modId: String
        public let recordId: String
        public let portalDataInfo: [PortalDataInfo]?
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
    
    public struct EmptyPortal: Decodable {
        
    }
}
```

#### Create Response
```swift
public struct CreateResponse: Decodable {
    public let recordId: String
    public let modId: String
    public let scriptResponse: ScriptResponse?
}
```
#### EditRecordResponse
```swift
public struct EditRecordResponse: Decodable {
    public let modId: String
    public let newPortalRecordInfo: CreatedPortalRecordInfo?
    public let scriptResponse: ScriptResponse?
    
    public struct CreatedPortalRecordInfo: Decodable {
        public let tableName: String
        public let recordId: String
        public let modId: String
    }
}
```
---
## Publishers (endpoints)
### A note about combine publishers

In the examples below we are going to look at just the publishers available.  Then you can add your own operators and subscribers. The publishers return decoded objects. The compiler will infer the type when you deal with the result for the record publishers.

### Metadata

#### Product Info

Function signature 
```swift
func getProductInfo() -> AnyPublisher<ProductInfo, FMRest.APIError>
```
Example
```swift
myServer.getProductInfo()
```

#### Database Names

This is the only publisher in the server context that requires credentials. This is just to get the list of servers that are available using these credentials. 

Function signature 
```swift
func getDatabaseNames(credentials: DataAPI.Credentials) -> AnyPublisher<DataAPI.Database.DatabaseListResponse, FMRest.APIError>
```
Example
```swift
myServer.getDatabaseNames(credentials: .init(user:"username",password:"password"))
```
#### Layout Names

Function signature
```swift
func getLayoutNames() -> AnyPublisher<[LayoutListItem], FMRest.APIError>
```
Example
```swift
myDatabase.getLayoutNames()
```

#### Script Names

Function signature
```swift
func getScriptNames() -> AnyPublisher<[ScriptItem], FMRest.APIError>
```
Example
```swift
myDatabase.getScriptNames()
```

#### Layout Metadata

Function signature
```swift
func getLayoutMetadata(recordId: Int?) -> AnyPublisher<LayoutMetaData, FMRest.APIError>
```
Example
```swift
myLayout.getLayoutMetadata()
```

### Authentication

#### Login

Function signature
```swift
func login(credentials: DataAPI.Credentials, dataSourceCredentials: DataAPI.FMDataSourceAuth? = nil) -> AnyPublisher<DataAPI.Credentials, FMRest.APIError>
```
Example
```swift
myDatabases.login(credentials: .init(user: "userName", password: "password"))

```

#### Log Out

Function signature
```swift
func logOut() -> AnyPublisher<FMRest.EmptyResponse, FMRest.APIError>
```
Example
```swift
myDatabase.logOut()
```

#### Validate Session

Only support for FileMaker Server v19+

Function signature
```swift
func validateSession(credentials: DataAPI.Credentials) -> AnyPublisher<FMRest.EmptyResponse, FMRest.APIError>
```
Example
```swift
myServer.validateSession(credentials: myDatabase.credentials)
```

### Records


#### Get Records

Function signature
```swift
func getRecords<R: Decodable, P: Decodable>(recordQuery: DataAPI.RecordQuery? = nil) -> AnyPublisher<DataAPI.RecordResponse<R,P>, FMRest.APIError>
```
Example
```swift
myLayout.getRecords()
```

#### Create Record
A possible record example
```swift
let person = Person(firstName: "Bob", lastName: "Jones")
let myRecord = EditRecord(createRecord: person)
```

Function signature
```swift
func createRecord<R: Encodable, P: Encodable>(record: DataAPI.EditRecord<R,P>) -> AnyPublisher<DataAPI.CreateResponse, FMRest.APIError>
```
Example
```swift
myLayout.createRecord(record: myRecord)
```

#### Get Single Record By Id

Function signature
```swift
func getRecordById<R: Decodable, P: Decodable>(recordId: Int, recordQuery: DataAPI.RecordQuery? = nil)
```
Example
```swift
myLayout.getRecordById(recordId: 123)
```

#### Edit Record
Start with a record we want to edit. It can be any encodable object.
```swift
let editRequestObject = EditRecord(editRecord: someObjectThatsEdited)
```

Function signature
```swift
func editRecord<R: Encodable, P: Encodable>(record: DataAPI.EditRecord<R,P>, recordId: Int) -> AnyPublisher<DataAPI.EditRecordResponse, FMRest.APIError>
```
Example
```swift
myLayout.editRecord(record: editRequestObject, recordId: 50)
```

#### Delete Record

Function signature
```swift
func deleteRecord(recordId: Int, scriptQuery: DataAPI.ScriptQuery? = nil) -> AnyPublisher<DataAPI.ScriptResponse, FMRest.APIError>
```
Example
```swift
myLayout.deleteRecord(recordId: 26)
```

#### Duplicate Record

Function signature
```swift
func duplicateRecord(recordId: Int, scriptQuery: DataAPI.ScriptQuery? = nil) -> AnyPublisher<DataAPI.ScriptResponse, FMRest.APIError>
```
Example
```swift
myLayout.duplicateRecord(recordId: 123)
```

#### Find Records

In this example we have a layout called locations
A query object
```swift
let cityQuery = FindQuery(query[["city":"Calgary"]])
```
Function signature
```swift
func findRecords<R: Decodable, P: Decodable>(query: DataAPI.FindQuery) -> AnyPublisher<DataAPI.RecordResponse<R,P>, FMRest.APIError>
```
Example
```swift
locations.findRecords(query: cityQuery)
```

### Scripts

#### Execute Script
Function signature
```swift
func executeScript(script: String, scriptParam: String? = nil) -> AnyPublisher<DataAPI.ScriptResponse, FMRest.APIError>
```
Example
```swift
myLayout.executeScript(script: "scriptToRun")
```

### Container

First we define the file for upload 

```swift
let myFile = ContainerFile(fileName: "FileName", mimeType: "image/jpg", data: fileData )
```
#### Upload To Container Field

Function signature
```swift
func uploadToContainerField(fieldName: String, recordId: Int, repetition: Int?, modId: Int?, file: FMRest.ContainerFile) -> AnyPublisher<FMRest.EmptyResponse, FMRest.APIError>
```
Example
```swift
myLayout.uploadToContainerField(fieldName: "containerFileName", recordId: 12, file: myFile)
```

#### Upload To Container Field ( specific repetition )

Example
```swift
myLayout.uploadToContainerField(fieldName: "containerFileName", recordId: 12, repetition: 2, file: myFile)
```

### Globals

#### Set Global Fields

Function signature
```swift
func setGlobalFields(globalFields: [String: String]) -> AnyPublisher<FMRest.EmptyResponse, FMRest.APIError>
```
Example
```swift
myDatabase.setGlobalFields(globalFields: ["fieldName"; "Value"])
```
